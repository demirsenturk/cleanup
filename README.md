# Azure Subscription Cleanup Script

Simple Bash script to delete all resource groups in one Azure subscription, or in all enabled subscriptions.

## Setup

```bash
git clone https://github.com/demirsenturk/cleanup.git
cd cleanup
chmod +x ./clean-up-azure-sub.sh
```

## Usage

Clean one subscription:

```bash
./clean-up-azure-sub.sh <subscription-id>
```

Clean all enabled subscriptions:

```bash
./clean-up-azure-sub.sh
```

## Notes

- Requires Bash and Azure CLI
- Requires an authenticated Azure session
- Run from a Bash-compatible shell such as Azure Cloud Shell, WSL, or Git Bash
- Single subscription mode asks for `y`
- All-subscriptions mode asks for `DELETE ALL`
- Deletions use `--no-wait`
- This permanently deletes resource groups and their contents
