import os
from datetime import datetime, timezone
from typing import Optional
from uuid import uuid4

import requests
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

SERVICE_BUS_CONNECTION_STRING = os.getenv("SERVICE_BUS_CONNECTION_STRING", "")
SERVICE_BUS_QUEUE_NAME = os.getenv("SERVICE_BUS_QUEUE_NAME", "notifications")
CATALOG_BASE_URL = os.getenv("CATALOG_BASE_URL", "http://catalog-service/catalog")
INVENTORY_RESERVE_URL = os.getenv("INVENTORY_RESERVE_URL", "http://inventory-service/inventory/reserve")
APPINSIGHTS_CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "")
KEY_VAULT_URI = os.getenv("KEY_VAULT_URI", "")

app = FastAPI(title="orders-service", version="1.0.0")


class OrderRequest(BaseModel):
    sku: str
    quantity: int
    customer: str


class Order(BaseModel):
    id: str
    sku: str
    quantity: int
    customer: str
    status: str
    created_at: str


orders: dict[str, Order] = {}


def publish_notification(order: Order) -> str:
    message_body = {
        "orderId": order.id,
        "recipient": order.customer,
        "channel": "email",
        "message": f"Order {order.id} accepted for {order.sku}",
    }
    if not SERVICE_BUS_CONNECTION_STRING:
        return "service-bus-not-configured"
    with ServiceBusClient.from_connection_string(SERVICE_BUS_CONNECTION_STRING) as client:
        sender = client.get_queue_sender(queue_name=SERVICE_BUS_QUEUE_NAME)
        with sender:
            sender.send_messages(ServiceBusMessage(str(message_body)))
    return "published-to-service-bus"


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "orders",
        "serviceBusConfigured": bool(SERVICE_BUS_CONNECTION_STRING),
        "appInsightsConfigured": bool(APPINSIGHTS_CONNECTION_STRING),
        "keyVaultConfigured": bool(KEY_VAULT_URI),
    }


@app.get("/orders")
def list_orders(status: Optional[str] = None) -> list[Order]:
    values = list(orders.values())
    if status:
        values = [order for order in values if order.status == status]
    return values


@app.post("/orders", status_code=201)
def create_order(request: OrderRequest) -> dict:
    if request.quantity <= 0:
        raise HTTPException(status_code=400, detail="Quantity must be positive")

    catalog_response = requests.get(f"{CATALOG_BASE_URL}/{request.sku}", timeout=5)
    if catalog_response.status_code == 404:
        raise HTTPException(status_code=404, detail="Catalog item not found")
    if catalog_response.status_code >= 400:
        raise HTTPException(status_code=502, detail="Catalog service failed")

    inventory_response = requests.post(
        INVENTORY_RESERVE_URL,
        json={"sku": request.sku, "quantity": request.quantity},
        timeout=5,
    )
    if inventory_response.status_code == 409:
        raise HTTPException(status_code=409, detail="Insufficient inventory")
    if inventory_response.status_code >= 400:
        raise HTTPException(status_code=502, detail="Inventory service failed")

    order = Order(
        id=str(uuid4()),
        sku=request.sku,
        quantity=request.quantity,
        customer=request.customer,
        status="accepted",
        created_at=datetime.now(timezone.utc).isoformat(),
    )
    orders[order.id] = order
    notification_status = publish_notification(order)
    return {"order": order, "notificationStatus": notification_status}


@app.get("/orders/{order_id}")
def get_order(order_id: str) -> Order:
    order = orders.get(order_id)
    if order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return order
