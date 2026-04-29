# API Management Routes

Use these routes when configuring API Management during the gateway lab.

| Public path | Backend during transition | Backend after extraction |
| --- | --- | --- |
| `/workshop/catalog/*` | eShopOnWeb PublicApi | catalog-service |
| `/workshop/orders/*` | eShopOnWeb Web/PublicApi | orders-service |
| `/workshop/inventory/*` | eShopOnWeb data access through monolith | inventory-service |
| `/workshop/notifications/*` | monolith email/notification path | notifications-service |

## Routing Strategy

1. Start APIM in front of the monolith without changing application behavior.
2. Add a catalog route and point it to the extracted catalog service.
3. Add an orders route and point it to the extracted orders service.
4. Keep fallbacks available during each lab so rollback means changing route configuration, not rebuilding the application.
