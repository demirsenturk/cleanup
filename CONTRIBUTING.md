# Contributing to Azure Subscription Cleanup Script

First off, thank you for considering contributing to this project! It's people like you that make this tool better for everyone.

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

**Bug Report Template:**
```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. With subscription ID '...'
3. See error

**Expected behavior**
A clear description of what you expected to happen.

**Environment:**
 - OS: [e.g., Ubuntu 22.04, macOS 13.0, Azure Cloud Shell]
 - Bash version: [e.g., 5.0.17]
 - Azure CLI version: [e.g., 2.50.0]

**Additional context**
Add any other context about the problem here.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- A clear and descriptive title
- A detailed description of the proposed functionality
- Explain why this enhancement would be useful
- List any alternative solutions or features you've considered

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the coding standards below
3. **Test your changes** thoroughly in different scenarios
4. **Update documentation** if you're changing functionality
5. **Write clear commit messages** following our commit message guidelines
6. **Submit your pull request** with a clear description of changes

## 📝 Coding Standards

### Bash Script Guidelines

- Use `#!/bin/bash` shebang
- Enable strict mode: `set -o errexit -o pipefail -o nounset`
- Use meaningful variable names in UPPERCASE for constants
- Use lowercase for local variables
- Add comments for complex logic
- Use functions to organize code
- Include function documentation headers
- Handle errors gracefully with informative messages

**Example function template:**
```bash
#------------------------------------------------------------------------------
# Function: function_name
# Description: Brief description of what the function does
# Arguments:
#   $1 - Description of first argument
#   $2 - Description of second argument
# Returns:
#   0 on success, 1 on failure
#------------------------------------------------------------------------------
function_name() {
  local arg1=$1
  local arg2=$2
  
  # Function logic here
  
  return 0
}
```

### Code Review Checklist

Before submitting a pull request, ensure:

- [ ] Code follows the project's style guidelines
- [ ] Comments are clear and explain complex logic
- [ ] All functions have proper documentation headers
- [ ] Error handling is implemented
- [ ] No hardcoded values (use variables or arguments)
- [ ] Code has been tested in Azure Cloud Shell
- [ ] Code has been tested on local Bash environment
- [ ] Documentation has been updated
- [ ] No sensitive information (subscription IDs, etc.) in code

## 🧪 Testing Guidelines

### Manual Testing

Test your changes with:

1. **Single subscription mode:**
   ```bash
   ./clean-up-azure-sub.sh --dry-run <test-subscription-id>
   ```

2. **Bulk mode (use with caution):**
   ```bash
   ./clean-up-azure-sub.sh --dry-run
   ```

3. **Error scenarios:**
   - Invalid subscription ID
   - No Azure CLI
   - Not logged in
   - Insufficient permissions
   - Empty subscriptions

### Test Environments

- Azure Cloud Shell (Bash)
- Local Linux (Ubuntu/Debian)
- Local macOS
- WSL (Windows Subsystem for Linux)

## 📄 Documentation

### README Updates

When adding features, update:
- Feature list
- Usage examples
- Troubleshooting section (if applicable)
- FAQ section (if applicable)

### Inline Documentation

- Add comments for non-obvious code
- Update function headers when changing behavior
- Document any new environment variables or options

## 🔀 Git Commit Messages

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only changes
- **style**: Formatting, missing semicolons, etc.
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests
- **chore**: Changes to build process or auxiliary tools

### Examples

```
feat(cleanup): add dry-run mode for preview

Add --dry-run flag that shows what would be deleted without
actually performing deletions. Useful for testing and verification.

Closes #42
```

```
fix(validation): improve subscription ID validation

Update regex pattern to properly validate GUID format.
Add better error messages when validation fails.
```

## 🌟 Recognition

Contributors will be:
- Listed in the project's acknowledgments
- Mentioned in release notes for significant contributions
- Credited in commit history

## 📞 Questions?

Feel free to:
- Open an issue for discussion
- Reach out to the maintainer
- Check existing issues and pull requests

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community

**Unacceptable behavior includes:**
- Harassment of any kind
- Trolling, insulting comments, or personal attacks
- Publishing others' private information
- Other unethical or unprofessional conduct

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by opening an issue or contacting the project maintainer. All complaints will be reviewed and investigated promptly and fairly.

---

Thank you for contributing to making Azure subscription management easier for everyone! 🚀
