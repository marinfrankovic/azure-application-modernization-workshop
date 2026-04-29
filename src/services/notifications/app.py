import ast
import os
from datetime import datetime, timezone
from typing import Optional

from azure.servicebus import ServiceBusClient
from fastapi import FastAPI
from pydantic import BaseModel

SERVICE_BUS_CONNECTION_STRING = os.getenv("SERVICE_BUS_CONNECTION_STRING", "")
SERVICE_BUS_QUEUE_NAME = os.getenv("SERVICE_BUS_QUEUE_NAME", "notifications")
APPINSIGHTS_CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "")
KEY_VAULT_URI = os.getenv("KEY_VAULT_URI", "")

app = FastAPI(title="notifications-service", version="1.0.0")


class Notification(BaseModel):
    channel: str = "email"
    recipient: str
    message: str
    orderId: Optional[str] = None


delivered: list[dict] = []


def record_notification(notification: Notification, source: str) -> dict:
    entry = {
        "id": len(delivered) + 1,
        "source": source,
        "channel": notification.channel,
        "recipient": notification.recipient,
        "message": notification.message,
        "orderId": notification.orderId,
        "status": "delivered-simulated",
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    delivered.append(entry)
    return entry


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "notifications",
        "serviceBusConfigured": bool(SERVICE_BUS_CONNECTION_STRING),
        "appInsightsConfigured": bool(APPINSIGHTS_CONNECTION_STRING),
        "keyVaultConfigured": bool(KEY_VAULT_URI),
    }


@app.post("/notifications", status_code=201)
def send_notification(notification: Notification) -> dict:
    return record_notification(notification, "http")


@app.get("/notifications")
def list_notifications() -> list[dict]:
    return delivered


@app.post("/notifications/process-next")
def process_next_message() -> dict:
    if not SERVICE_BUS_CONNECTION_STRING:
        return {"status": "skipped", "reason": "SERVICE_BUS_CONNECTION_STRING is not configured"}

    with ServiceBusClient.from_connection_string(SERVICE_BUS_CONNECTION_STRING) as client:
        receiver = client.get_queue_receiver(queue_name=SERVICE_BUS_QUEUE_NAME, max_wait_time=5)
        with receiver:
            messages = receiver.receive_messages(max_message_count=1, max_wait_time=5)
            if not messages:
                return {"status": "empty"}
            message = messages[0]
            payload = ast.literal_eval(str(message))
            notification = Notification(
                channel=payload.get("channel", "email"),
                recipient=payload["recipient"],
                message=payload["message"],
                orderId=payload.get("orderId"),
            )
            entry = record_notification(notification, "service-bus")
            receiver.complete_message(message)
            return entry
