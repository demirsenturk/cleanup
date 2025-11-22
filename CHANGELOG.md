# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-22

### 🎉 Initial Release

#### Added
- Core cleanup functionality for Azure resource groups
- Single subscription cleanup mode
- Bulk cleanup mode for all enabled subscriptions
- Color-coded logging system (INFO, SUCCESS, WARNING, ERROR)
- Azure CLI prerequisite checking
- User authentication validation
- Multi-level confirmation prompts for safety
- Subscription ID format validation (GUID)
- `--help` flag for usage information
- `--version` flag for version information
- `--dry-run` mode to preview deletions without executing
- `--verbose` flag for detailed debugging output
- Asynchronous deletion with `--no-wait` flag
- Resource group counting and progress tracking
- Failed operation tracking in bulk mode
- Direct Azure Portal links for monitoring
- Error handling with informative messages
- Graceful handling of empty subscriptions
- MIT License
- Comprehensive README with examples and troubleshooting
- Professional documentation structure
- CONTRIBUTING.md for contributors
- SECURITY.md for security best practices
- Proper .gitignore for Bash/Azure projects

#### Security
- Requires explicit confirmation before deletions
- Bulk mode requires typing "DELETE ALL" exactly
- Input validation for subscription IDs
- No hardcoded credentials or sensitive data
- All operations logged through Azure Activity Log

#### Developer Experience
- Well-documented functions with headers
- Consistent code style and formatting
- Strict mode enabled (errexit, pipefail, nounset)
- Modular function-based architecture
- Clear separation of concerns

### Known Limitations
- Deletions are asynchronous and may take time to complete
- No built-in rollback mechanism (Azure limitation)
- Requires Bash 4.0 or higher
- Only processes "Enabled" subscriptions in bulk mode

### Tested Environments
- ✅ Azure Cloud Shell (Bash)
- ✅ Ubuntu 20.04+
- ✅ macOS 12+
- ✅ WSL2 (Ubuntu)

---

## [Unreleased]

### Planned Features
- Configuration file support for subscription whitelisting/blacklisting
- Export deletion report to JSON/CSV
- Integration with Azure DevOps pipelines
- Parallel subscription processing option
- Email notification support
- Resource-level filtering options
- Exclude specific resource groups by pattern
- Schedule-based cleanup
- Cost estimation before deletion

### Under Consideration
- Support for Azure Government Cloud
- Support for Azure China Cloud
- Interactive mode with menu selection
- Undo/recovery assistance guide
- Integration with Azure Policy
- Terraform state cleanup

---

## Version History

### [1.0.0] - 2025-11-22
- Initial public release

---

## How to Contribute

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Support

- 🐛 **Bug Reports**: [Open an issue](https://github.com/demirsenturk/azure-subscription-cleanup/issues)
- 💡 **Feature Requests**: [Open an issue](https://github.com/demirsenturk/azure-subscription-cleanup/issues)
- 📖 **Documentation**: [README.md](README.md)
- 🔒 **Security**: [SECURITY.md](SECURITY.md)

---

**Note**: Always review changes and test in non-production environments before using in production. This script permanently deletes Azure resources.
