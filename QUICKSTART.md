# Quickstart

```bash
git clone https://github.com/demirsenturk/cleanup.git
cd cleanup
chmod +x ./clean-up-azure-sub.sh
az login
az account list --output table
./clean-up-azure-sub.sh <subscription-id>
```

To clean all enabled subscriptions:

```bash
./clean-up-azure-sub.sh
```
