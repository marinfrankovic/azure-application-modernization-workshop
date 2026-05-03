# 02 - Architecture Overview - Azure Portal

## Objective

Understand the source and destination topology in the Azure portal.

## Steps

1. Create the source resource group.
2. Create or locate the source VNet and source app resource.
3. Create a separate destination resource group.
4. Plan destination address space:
   - Track A: `10.20.0.0/16`.
   - Track B: `10.30.0.0/16`.
   - Track C: `10.40.0.0/16`.
5. Confirm no overlap with source.

## Expected Outcome

You can point to the source and destination environments that you created in the portal.
