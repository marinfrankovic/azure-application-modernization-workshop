import os

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

APPINSIGHTS_CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "")
KEY_VAULT_URI = os.getenv("KEY_VAULT_URI", "")

app = FastAPI(title="inventory-service", version="1.0.0")


class InventoryChange(BaseModel):
    sku: str
    quantity: int


inventory: dict[str, int] = {
    "SKU-100": 25,
    "SKU-200": 40,
    "SKU-300": 120,
}


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "inventory",
        "appInsightsConfigured": bool(APPINSIGHTS_CONNECTION_STRING),
        "keyVaultConfigured": bool(KEY_VAULT_URI),
    }


@app.get("/inventory")
def list_inventory() -> list[dict]:
    return [{"sku": sku, "quantity": quantity} for sku, quantity in sorted(inventory.items())]


@app.get("/inventory/{sku}")
def get_inventory(sku: str) -> dict:
    if sku not in inventory:
        raise HTTPException(status_code=404, detail="SKU not found")
    return {"sku": sku, "quantity": inventory[sku]}


@app.post("/inventory/reserve")
def reserve(change: InventoryChange) -> dict:
    if change.quantity <= 0:
        raise HTTPException(status_code=400, detail="Quantity must be positive")
    available = inventory.get(change.sku)
    if available is None:
        raise HTTPException(status_code=404, detail="SKU not found")
    if available < change.quantity:
        raise HTTPException(status_code=409, detail="Insufficient inventory")
    inventory[change.sku] = available - change.quantity
    return {"sku": change.sku, "reserved": change.quantity, "remaining": inventory[change.sku]}


@app.post("/inventory/replenish")
def replenish(change: InventoryChange) -> dict:
    if change.quantity <= 0:
        raise HTTPException(status_code=400, detail="Quantity must be positive")
    inventory[change.sku] = inventory.get(change.sku, 0) + change.quantity
    return {"sku": change.sku, "quantity": inventory[change.sku]}
