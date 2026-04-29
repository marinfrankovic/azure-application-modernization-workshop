# 08 - Validate Source Baseline

## Objective

Verify eShopOnWeb is healthy in the prepared source environment before decomposition begins.

## Architecture Explanation

A modernization workshop needs a known-good source. If the source monolith is unhealthy, decomposition testing becomes confusing because failures may come from the source instead of the destination.

## Azure Services Used

- Source application hosting.
- Log Analytics for source logs.
- Source VNet.

## Steps

1. Open the source eShopOnWeb URL provided by the facilitator.
2. Browse catalog pages and confirm the application responds.
3. Record source resource group, VNet, app URL, and region.
4. Check source logs if access is provided.
5. Mark the baseline as ready in your worksheet.

## Expected Outcome

The source monolith is confirmed healthy and ready for destination decomposition labs.
