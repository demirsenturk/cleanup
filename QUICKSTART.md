# Quick Reference Guide

## ⚡ Quick Commands

### Basic Usage

```bash
# Show help
./clean-up-azure-sub.sh --help

# Show version
./clean-up-azure-sub.sh --version

# Preview deletion (recommended first step)
./clean-up-azure-sub.sh --dry-run <subscription-id>

# Delete specific subscription
./clean-up-azure-sub.sh <subscription-id>

# Delete all subscriptions (use with extreme caution)
./clean-up-azure-sub.sh
```

## 📋 Pre-Flight Checklist

Before running the script:

- [ ] Azure CLI installed and logged in (`az login`)
- [ ] Correct subscription IDs identified
- [ ] Tested with `--dry-run` first
- [ ] Backups of important data created
- [ ] Stakeholders notified (if applicable)
- [ ] Resource locks checked
- [ ] Production subscriptions excluded

## 🎯 Common Scenarios

### Scenario 1: Clean up a single dev subscription

```bash
# Step 1: Preview
./clean-up-azure-sub.sh --dry-run 12345678-1234-1234-1234-123456789012

# Step 2: Review output

# Step 3: Execute
./clean-up-azure-sub.sh 12345678-1234-1234-1234-123456789012
```

### Scenario 2: List subscriptions first

```bash
# See what subscriptions you have access to
az account list --output table

# Then clean up a specific one
./clean-up-azure-sub.sh <subscription-id-from-list>
```

### Scenario 3: Check what's in a subscription before cleanup

```bash
# Set subscription
az account set --subscription <subscription-id>

# List all resource groups
az group list --output table

# Then run cleanup
./clean-up-azure-sub.sh <subscription-id>
```

## 🔍 Verification Commands

### Check if you're logged in
```bash
az account show
```

### List all your subscriptions
```bash
az account list --output table
```

### List resource groups in current subscription
```bash
az group list --output table
```

### Check your permissions
```bash
az role assignment list --assignee <your-email> --output table
```

### Monitor deletion progress
```bash
# Via CLI
az group list --output table

# Via Portal
# Visit: https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups
```

## ⚠️ Safety Reminders

| ⚠️ Warning | What to Do |
|------------|------------|
| **Production Subscription** | ❌ Don't use this script |
| **Uncertain about subscription** | ✅ Use `--dry-run` first |
| **Multiple subscriptions** | ✅ Process one at a time |
| **Important data** | ✅ Backup first |
| **Resource locks exist** | ✅ They will prevent deletion (good!) |

## 🆘 Emergency Stop

If you run the script by accident:

1. **Immediately press `Ctrl+C`** to stop the script
2. **Check Azure Activity Log** to see what was deleted
3. **Contact Azure Support** within 14 days for possible recovery
4. **Review your backup strategy**

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "Permission denied" | `chmod +x clean-up-azure-sub.sh` |
| "Azure CLI not found" | Install Azure CLI or use Cloud Shell |
| "Not logged in" | Run `az login` |
| "Invalid subscription ID" | Check format: GUID with hyphens |
| "No subscriptions found" | Verify account has subscription access |
| Script hangs | Wait 2-3 minutes, check Azure service status |

## 📱 Quick Links

- **Azure Portal**: https://portal.azure.com
- **Azure Status**: https://status.azure.com
- **Activity Log**: Portal → Monitor → Activity Log
- **Cost Analysis**: Portal → Cost Management → Cost Analysis
- **Resource Groups**: Portal → Resource Groups

## 💰 Cost Impact

### Estimate savings

```bash
# Check current month costs for a subscription
az consumption usage list \
  --start-date $(date -d "1 day ago" +%Y-%m-%d) \
  --end-date $(date +%Y-%m-%d) \
  --output table
```

### What gets deleted

When you delete a resource group, ALL resources inside are deleted:
- Virtual Machines
- Storage Accounts
- Databases
- Networks
- Everything else in that resource group

## 🎓 Learning Resources

### For Beginners
1. Start with `--help` to understand options
2. Use `--dry-run` extensively
3. Test on a single, non-critical subscription first
4. Read the FAQ in README.md

### For Advanced Users
1. Review the source code for customization ideas
2. Check SECURITY.md for production considerations
3. See CONTRIBUTING.md to add features
4. Read CHANGELOG.md for version history

## 📞 Getting Help

1. **Check the FAQ** in README.md
2. **Review SECURITY.md** for safety guidelines
3. **Search existing issues** on GitHub
4. **Open a new issue** with details
5. **Contact Azure Support** for Azure-specific issues

---

**Remember**: This script is a powerful tool. With great power comes great responsibility. Always verify before executing! 🦸‍♂️
