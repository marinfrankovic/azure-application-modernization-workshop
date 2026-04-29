# Monolith Source

This workshop uses eShopOnWeb as the monolith source application.

The source is included as a git submodule at `src/monolith/eShopOnWeb`:

```powershell
git submodule update --init --recursive
```

## Why eShopOnWeb

eShopOnWeb is a realistic ASP.NET Core reference application with catalog, basket, ordering, identity, data access, and web/API entry points. That makes it a useful modernization source because participants can practice identifying boundaries in a real codebase instead of a synthetic demo.

## Workshop Use

Labs use eShopOnWeb for:

- Baseline monolith run and validation.
- Domain and bounded-context discovery.
- Containerization of the existing application.
- API gateway routing decisions.
- Extraction planning for catalog, orders, inventory, and notifications.
- Data ownership and dependency mapping.

The extracted service examples under `src/services` are intentionally small teaching targets that show the desired shape after decomposition.