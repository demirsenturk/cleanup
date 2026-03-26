# Azure Subscription Cleanup Script

Simple Bash script to delete all resource groups in one Azure subscription, or in all enabled subscriptions.

## Usage

```bash
./clean-up-azure-sub.sh <subscription-id>
./clean-up-azure-sub.sh
```

## Notes

- Requires Bash and Azure CLI
- Requires an authenticated Azure session
- Single subscription mode asks for `y`
- All-subscriptions mode asks for `DELETE ALL`
- Deletions use `--no-wait`
- This permanently deletes resource groups and their contents
