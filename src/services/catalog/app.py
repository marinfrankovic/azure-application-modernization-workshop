import os
from typing import Optional

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

APPINSIGHTS_CONNECTION_STRING = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING", "")
KEY_VAULT_URI = os.getenv("KEY_VAULT_URI", "")

app = FastAPI(title="catalog-service", version="1.0.0")


class CatalogItem(BaseModel):
    sku: str
    name: str
    price: float
    description: Optional[str] = None


catalog: dict[str, CatalogItem] = {
    "SKU-100": CatalogItem(sku="SKU-100", name="Migration Backpack", price=79.0, description="Carry the workshop essentials."),
    "SKU-200": CatalogItem(sku="SKU-200", name="Refactor Hoodie", price=59.0, description="For chilly decomposition sessions."),
    "SKU-300": CatalogItem(sku="SKU-300", name="Event-driven Mug", price=15.0, description="Pairs well with async messaging."),
}


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "catalog",
        "appInsightsConfigured": bool(APPINSIGHTS_CONNECTION_STRING),
        "keyVaultConfigured": bool(KEY_VAULT_URI),
    }


@app.get("/catalog")
def list_items() -> list[CatalogItem]:
    return list(catalog.values())


@app.get("/catalog/{sku}")
def get_item(sku: str) -> CatalogItem:
    item = catalog.get(sku)
    if item is None:
        raise HTTPException(status_code=404, detail="Catalog item not found")
    return item


@app.put("/catalog/{sku}")
def upsert_item(sku: str, item: CatalogItem) -> CatalogItem:
    if sku != item.sku:
        raise HTTPException(status_code=400, detail="SKU in path and body must match")
    if item.price < 0:
        raise HTTPException(status_code=400, detail="Price cannot be negative")
    catalog[sku] = item
    return item
