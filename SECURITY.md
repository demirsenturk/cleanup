# Security Policy

## 🔒 Security Considerations

This script has the power to **permanently delete all resource groups** in Azure subscriptions. Please treat it with the appropriate level of caution and security awareness.

## ⚠️ Important Security Notes

### Script Capabilities

This script can:
- Delete all resource groups in a subscription
- Process multiple subscriptions at once
- Operate with the permissions of the authenticated Azure user

### Recommended Security Practices

1. **Never run this script with production credentials** unless you fully understand the consequences
2. **Use separate accounts** for production and non-production environments
3. **Review subscription lists** carefully before running in bulk mode
4. **Test with `--dry-run` first** to preview what will be deleted
5. **Implement Azure Policy** to prevent accidental deletions in critical subscriptions
6. **Use Resource Locks** on production resource groups
7. **Maintain proper RBAC** (Role-Based Access Control) to limit who can delete resources
8. **Enable Azure Activity Logs** to track all deletion operations
9. **Never commit credentials** to version control
10. **Review the script** before running it in your environment

## 🛡️ Azure Security Best Practices

### Principle of Least Privilege

Only grant the minimum necessary permissions:
- Use **Contributor** role only where needed
- Consider using **Resource Group Contributor** for limited scope
- Avoid using **Owner** role unless absolutely necessary

### Multi-Factor Authentication (MFA)

- Enable MFA for all Azure accounts
- Especially critical for accounts with deletion permissions

### Audit and Monitoring

- Enable Azure Activity Log
- Set up alerts for resource deletions
- Regularly review who has access to subscriptions
- Use Azure Policy to enforce organizational standards

### Resource Protection

```bash
# Example: Add a lock to prevent deletion
az lock create --name DontDelete \
  --resource-group Production-RG \
  --lock-type CanNotDelete
```

## 🐛 Reporting a Vulnerability

If you discover a security vulnerability in this script, please help us by reporting it responsibly.

### Reporting Process

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. **Email the maintainer** directly with details:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

3. **Wait for acknowledgment** - We aim to respond within 48 hours
4. **Allow time for a fix** - We will work to address the issue promptly
5. **Coordinate disclosure** - We will coordinate with you on public disclosure timing

### What to Report

Please report issues such as:
- Command injection vulnerabilities
- Privilege escalation possibilities
- Unintended data exposure
- Authentication/authorization bypasses
- Logic flaws that could cause unintended deletions

### What NOT to Report

Please don't report:
- Issues related to Azure CLI itself (report to Microsoft)
- Expected behavior (script is designed to delete resources)
- Social engineering scenarios
- Issues requiring physical access to a machine

## 🔐 Secure Usage Guidelines

### For Beginners

1. **Start with `--dry-run`** to understand what the script does
2. **Test in a sandbox subscription** first
3. **Never use with production subscriptions** until you fully understand the tool
4. **Always read the confirmation prompts** carefully
5. **Keep backups** of important data

### For Advanced Users

1. **Review the source code** before running
2. **Consider forking** and customizing for your environment
3. **Implement additional safeguards** (e.g., subscription whitelisting)
4. **Integrate with CI/CD carefully** with proper approval gates
5. **Use Azure DevOps Service Connections** with limited scope
6. **Log all operations** for audit trails

## 📋 Pre-Execution Checklist

Before running this script, verify:

- [ ] You're authenticated to the correct Azure account
- [ ] You understand which subscriptions will be affected
- [ ] You have reviewed the list of subscriptions/resource groups
- [ ] You have backups of any important data
- [ ] You have tested with `--dry-run` first
- [ ] You have proper authorization to perform these operations
- [ ] You understand this action cannot be undone
- [ ] You have reviewed the script code

## 🚨 Incident Response

### If You Accidentally Delete Resources

1. **Stop the script** immediately (Ctrl+C)
2. **Document what was deleted** (check Azure Activity Log)
3. **Contact Azure Support** if recovery is needed (within 14 days for some resources)
4. **Review your backup and disaster recovery procedures**
5. **Implement preventive measures** to avoid future incidents

### Azure Activity Log

Check deletions in the portal:
```
Home > Monitor > Activity Log > Filter by "Delete Resource Group"
```

Or via CLI:
```bash
az monitor activity-log list \
  --resource-group <resource-group> \
  --start-time 2025-11-22T00:00:00Z \
  --query "[?contains(operationName.value, 'Delete')]"
```

## 📞 Support

For security-related questions:
- Review Azure Security Best Practices documentation
- Consult with your organization's security team
- Contact Azure Support for platform-specific guidance

## 📜 Compliance

### Data Protection

- This script does not store or transmit data outside of Azure
- All operations use Azure CLI which follows Azure's security protocols
- No data is logged except through Azure's native logging

### Regulatory Compliance

If you operate in regulated industries:
- Ensure deletions comply with data retention policies
- Maintain audit logs as required by regulations
- Implement approval workflows before executing
- Document all cleanup operations

## 🔄 Updates and Patches

- Watch the repository for security updates
- Subscribe to release notifications
- Review changelogs before updating
- Test updates in non-production first

## ✅ Security Verification

You can verify the script by:
1. Reading the source code (it's fully open)
2. Checking for hardcoded credentials (there are none)
3. Reviewing all Azure CLI commands used
4. Testing in a safe environment first

---

**Remember**: Security is a shared responsibility. This script is a tool - how you use it determines its safety. Always prioritize the principle of least privilege and verify before executing.

Last updated: November 22, 2025
