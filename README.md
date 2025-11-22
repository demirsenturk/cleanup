# Azure Subscription Cleanup Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/bash-5.0+-blue.svg)](https://www.gnu.org/software/bash/)
[![Azure CLI](https://img.shields.io/badge/Azure%20CLI-2.0+-0078D4.svg)](https://docs.microsoft.com/en-us/cli/azure/)

A powerful and safe Bash script to clean up Azure resource groups across one or multiple subscriptions. Designed for Azure Cloud Shell with built-in safety confirmations and progress tracking.

## 🎯 Overview

This script automates the deletion of all resource groups in your Azure subscription(s), making it ideal for:
- 🧹 Cleaning up development/test environments
- 💰 Cost optimization by removing unused resources
- 🔄 Resetting demo or training environments
- 🧪 Cleaning up after experiments or POCs

> 📖 **New to this tool?** Check out [QUICKSTART.md](QUICKSTART.md) for a quick reference guide!

## ✨ Features

- **Single Subscription Mode**: Clean up a specific subscription by providing its ID
- **Bulk Cleanup Mode**: Process all enabled subscriptions at once
- **Safety First**: Multiple confirmation prompts prevent accidental deletions
- **Progress Tracking**: Clear output showing which subscriptions and resource groups are being processed
- **Error Handling**: Gracefully handles subscriptions with no resource groups
- **Async Operations**: Uses `--no-wait` flag for faster, non-blocking deletions
- **Detailed Logging**: Shows subscription names, IDs, and resource group lists before deletion

## 📋 Prerequisites

Before using this script, ensure you have:

- ✅ Access to Azure CLI (Azure Cloud Shell recommended)
- ✅ Appropriate permissions to delete resource groups in target subscriptions
- ✅ Bash shell environment (version 4.0 or higher)
- ✅ Active Azure subscription(s)

## 🚀 Quick Start

### Installation

#### Option 1: Clone from GitHub (Recommended)

```bash
# Clone the repository
git clone https://github.com/demirsenturk/azure-subscription-cleanup.git
cd azure-subscription-cleanup

# Make the script executable
chmod +x clean-up-azure-sub.sh

# Verify installation
./clean-up-azure-sub.sh --version
```

#### Option 2: Direct Download in Azure Cloud Shell

```bash
# Download the script directly
curl -o clean-up-azure-sub.sh https://raw.githubusercontent.com/demirsenturk/azure-subscription-cleanup/main/clean-up-azure-sub.sh

# Make it executable
chmod +x clean-up-azure-sub.sh

# Run it
./clean-up-azure-sub.sh --help
```

### Usage

#### Option 1: Clean Up a Specific Subscription

```bash
./clean-up-azure-sub.sh <subscription-id>
```

**Example**:
```bash
./clean-up-azure-sub.sh 12345678-1234-1234-1234-123456789012
```

**What happens**:
1. Sets the specified subscription as active
2. Displays subscription name and ID
3. Lists all resource groups to be deleted
4. Asks for confirmation (y/n)
5. Deletes all resource groups in that subscription

#### Option 2: Clean Up ALL Subscriptions

```bash
./clean-up-azure-sub.sh
```

**What happens**:
1. Queries all your enabled subscriptions
2. Displays a list of all subscriptions that will be processed
3. Asks for explicit confirmation (requires typing `DELETE ALL`)
4. Processes each subscription sequentially
5. Deletes all resource groups in all subscriptions

## 📊 Sample Output

### Single Subscription Mode

```
You are about to delete all resource groups in the subscription:
Subscription Name: My Dev Subscription
Subscription ID: 12345678-1234-1234-1234-123456789012
Are you sure you want to proceed? (y/n): y

==================================================
Processing subscription: My Dev Subscription
Subscription ID: 12345678-1234-1234-1234-123456789012
==================================================
Found resource groups:
  - rg-dev-app
  - rg-dev-storage
  - rg-dev-network
Deleting resource group: rg-dev-app
Deleting resource group: rg-dev-storage
Deleting resource group: rg-dev-network
All resource groups in My Dev Subscription have been scheduled for deletion.
```

### All Subscriptions Mode

```
No subscription ID provided. Will process ALL subscriptions.

Found the following enabled subscriptions:
  - Dev Subscription (12345678-1234-1234-1234-123456789012)
  - Test Subscription (87654321-4321-4321-4321-210987654321)
  - Staging Subscription (11111111-2222-3333-4444-555555555555)

WARNING: This will delete ALL resource groups in ALL of your enabled subscriptions!
Are you absolutely sure you want to proceed? Type 'DELETE ALL' to confirm: DELETE ALL

Starting cleanup of all subscriptions...

==================================================
Processing subscription: Dev Subscription
Subscription ID: 12345678-1234-1234-1234-123456789012
==================================================
Found resource groups:
  - rg-dev-app
  - rg-dev-storage
Deleting resource group: rg-dev-app
Deleting resource group: rg-dev-storage
All resource groups in Dev Subscription have been scheduled for deletion.

==================================================
Processing subscription: Test Subscription
Subscription ID: 87654321-4321-4321-4321-210987654321
==================================================
No resource groups found in subscription: Test Subscription

==================================================
All subscriptions have been processed.
All resource groups have been scheduled for deletion.
==================================================
```

## 🛡️ Safety Features

### Multi-Level Confirmations

| Mode | Confirmation Required |
|------|----------------------|
| **Single Subscription** | Simple y/n confirmation |
| **All Subscriptions** | Must type `DELETE ALL` exactly |

### Pre-Deletion Information

- ✅ Shows subscription names and IDs before deletion
- ✅ Lists all resource groups that will be deleted
- ✅ Handles empty subscriptions gracefully
- ✅ Operation can be cancelled at confirmation prompt

### Asynchronous Processing

- Uses `az group delete --no-wait` for non-blocking deletions
- Multiple deletions can run in parallel
- Monitor deletion progress in Azure Portal under "Activity Log"

## ⚠️ Important Warnings

> **CRITICAL**: This script will permanently delete ALL resource groups in the specified subscription(s). This action **CANNOT BE UNDONE**.

- 🔴 All resources within the resource groups will be deleted
- 🔴 Deletion happens asynchronously and continues even if the script exits
- 🔴 Only **enabled** subscriptions are processed in bulk mode
- 🔴 Always verify the subscription ID/name before confirming
- 🔴 Test in a non-production environment first

## ❓ Frequently Asked Questions (FAQ)

### General Questions

**Q: Is this safe to use?**  
A: The script itself is safe and includes multiple confirmation prompts. However, it permanently deletes resources, so always use `--dry-run` first and verify you're targeting the correct subscriptions.

**Q: Can I recover deleted resource groups?**  
A: No. Resource group deletion is permanent and cannot be undone. Always maintain backups of critical data.

**Q: How long does deletion take?**  
A: Deletions are asynchronous. Small resource groups may complete in minutes, while large ones with many resources can take 30+ minutes.

**Q: Will this delete locked resources?**  
A: No. Resources with Azure Resource Locks will fail to delete, and you'll see an error message.

**Q: Does this work in Azure Government or China Cloud?**  
A: Currently optimized for Azure Commercial Cloud. Government and China clouds should work but aren't officially tested.

### Usage Questions

**Q: What's the difference between single and bulk mode?**  
A: Single mode targets one specific subscription (by ID). Bulk mode processes ALL enabled subscriptions in your account.

**Q: How do I test without deleting anything?**  
A: Use the `--dry-run` flag: `./clean-up-azure-sub.sh --dry-run <subscription-id>`

**Q: Can I exclude specific resource groups?**  
A: Not in v1.0.0. This feature is planned for a future release. For now, manually delete specific groups via Azure Portal.

**Q: Will this affect my subscription itself?**  
A: No. Only resource groups and their contents are deleted. The subscription remains active.

**Q: Can I run this in a script or pipeline?**  
A: Yes, but be extremely careful. You'll need to bypass interactive confirmations (not recommended without safeguards).

### Technical Questions

**Q: What Azure CLI version is required?**  
A: Azure CLI 2.0 or higher. Check with `az --version`.

**Q: Does this work on Windows?**  
A: Yes, via WSL (Windows Subsystem for Linux) or Azure Cloud Shell. Native Windows PowerShell is not supported.

**Q: Why use `--no-wait` flag?**  
A: It allows multiple deletions to proceed in parallel, significantly speeding up the process for many resource groups.

**Q: Where can I see deletion progress?**  
A: In the Azure Portal under Activity Log, or at https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups

**Q: What happens if the script is interrupted?**  
A: Already-initiated deletions will continue. Resource groups scheduled with `--no-wait` will complete asynchronously.

## 🔧 Troubleshooting

### Permission Denied Error

```bash
chmod +x clean-up-azure-sub.sh
```

### Azure CLI Not Found

Ensure you're running the script in:
- Azure Cloud Shell (recommended), or
- A local environment with Azure CLI installed and authenticated

```bash
# Verify Azure CLI installation
az --version

# Login to Azure
az login
```

### No Subscriptions Found

Verify:
- ✅ You're logged into the correct Azure account
- ✅ Your account has access to subscriptions
- ✅ Subscriptions are in "Enabled" state

```bash
# List all accessible subscriptions
az account list --output table
```

### Insufficient Permissions

Ensure you have:
- `Contributor` or `Owner` role on the subscription(s)
- Permission to delete resource groups

```bash
# Check your role assignments
az role assignment list --assignee <your-email> --output table
```

### Script Hangs or Times Out

If the script appears to hang:
1. Wait a few minutes (Azure API calls can be slow)
2. Check your internet connection
3. Verify Azure service health: https://status.azure.com
4. Try again with a single subscription first

### "Invalid Subscription ID" Error

Ensure the subscription ID is:
- A valid GUID format (e.g., `12345678-1234-1234-1234-123456789012`)
- An actual subscription you have access to
- Not disabled or expired

## 💡 Use Cases

### Development Teams
- Clean up dev/test environments after sprints
- Reset demo environments for presentations
- Remove experimental POC resources

### Cost Optimization
- Delete unused test subscriptions to reduce costs
- Clean up abandoned resources
- Periodic cleanup of sandbox environments

### Training & Education
- Reset lab environments for new training sessions
- Clean up student subscriptions after courses
- Prepare demo environments

### CI/CD Integration
- Clean up ephemeral test environments
- Teardown temporary infrastructure
- Cost-controlled automated testing

## 📁 Repository Structure

```
.
├── clean-up-azure-sub.sh    # Main cleanup script
├── README.md                 # This file - comprehensive documentation
├── QUICKSTART.md             # Quick reference guide for fast access
├── CONTRIBUTING.md           # Contribution guidelines
├── SECURITY.md               # Security best practices and policies
├── CHANGELOG.md              # Version history and release notes
├── LICENSE                   # MIT License
└── .gitignore               # Git ignore patterns
```

### 📚 Documentation Guide

- **New users?** Start with [QUICKSTART.md](QUICKSTART.md)
- **Want to contribute?** Read [CONTRIBUTING.md](CONTRIBUTING.md)
- **Security concerns?** Check [SECURITY.md](SECURITY.md)
- **What's new?** See [CHANGELOG.md](CHANGELOG.md)

## 🚦 Best Practices

### Before Running

1. ✅ **Always use `--dry-run` first** to preview deletions
2. ✅ **Verify subscription IDs** carefully
3. ✅ **Check resource group list** before confirming
4. ✅ **Ensure you have backups** of any important data
5. ✅ **Review who will be impacted** by resource deletions
6. ✅ **Check for resource locks** that might prevent deletion
7. ✅ **Verify you're logged into the correct account**

### For Production Environments

⚠️ **This script is designed for dev/test environments**. For production:

1. **Implement Resource Locks** to prevent accidental deletion
2. **Use Azure Policy** to enforce organizational standards
3. **Enable RBAC** with principle of least privilege
4. **Maintain comprehensive backups**
5. **Use separate accounts** for production access
6. **Require approval workflows** for any deletions
7. **Enable audit logging** and monitoring

### Cost Monitoring

Before deletion, check estimated costs:

```bash
# Check cost for a resource group
az consumption usage list \
  --resource-group <resource-group-name> \
  --start-date 2025-11-01 \
  --end-date 2025-11-22
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Quick Contribution Guide

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Demir Senturk**

- GitHub: [@demirsenturk](https://github.com/demirsenturk)

## 🙏 Acknowledgments

- Built for Azure Cloud Shell and local Bash environments
- Utilizes Azure CLI for all Azure operations
- Inspired by the need for quick and safe environment cleanup
- Community feedback and contributions

## 🔗 Related Projects

- [Azure CLI](https://github.com/Azure/azure-cli) - Microsoft's official Azure command-line tool
- [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/) - Infrastructure as Code for Azure

## 📚 Additional Resources

### Azure Documentation
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure Resource Manager Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/)
- [Azure Cloud Shell Overview](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
- [Azure Resource Locks](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview)

### Best Practices
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [Azure Cost Management](https://docs.microsoft.com/en-us/azure/cost-management-billing/)
- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)

### Community
- [Azure Community Support](https://azure.microsoft.com/en-us/support/community/)
- [Azure DevOps Labs](https://azuredevopslabs.com/)

## 📊 Project Status

![GitHub release (latest by date)](https://img.shields.io/github/v/release/demirsenturk/azure-subscription-cleanup)
![GitHub issues](https://img.shields.io/github/issues/demirsenturk/azure-subscription-cleanup)
![GitHub pull requests](https://img.shields.io/github/issues-pr/demirsenturk/azure-subscription-cleanup)

**Current Version**: 1.0.0  
**Status**: Active Development  
**Last Updated**: November 22, 2025

## 🛣️ Roadmap

See [CHANGELOG.md](CHANGELOG.md) for planned features and version history.

---

⭐ **If you find this script helpful, please consider giving it a star!** ⭐

---

## ⚠️ Final Reminder

**This script permanently deletes Azure resources. Always:**
- ✅ Test with `--dry-run` first
- ✅ Verify subscription IDs
- ✅ Maintain backups
- ✅ Understand the impact
- ✅ Exercise caution

**For Production**: Implement Azure Policy, Resource Locks, and proper RBAC to prevent accidental deletions.

---

*Made with ❤️ for the Azure community*
