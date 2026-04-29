# 10 - Containerize And Stage Services

## Objective

Build extracted service containers and stage them in the selected destination environment.

## Architecture Explanation

The source monolith remains running while extracted services are deployed into destination. This enables side-by-side validation before traffic shifts.

## Azure Services Used

- Track A: Container Apps.
- Track B: ACR and AKS.
- Track C: private ACR and regulated deployment admission path.

## Steps

1. Build local service images from `src/services`.
2. For Track A, publish service images and update Container Apps image settings.
3. For Track B, run:

```powershell
./scripts/deploy-services.ps1 -ResourceGroupName rg-appmod-dest-b -Prefix appmodb
```

4. For Track C, push images only through approved private network paths.
5. Validate `/health` on each service.

## Expected Outcome

Extracted service containers are deployed but not yet considered authoritative for all traffic.
