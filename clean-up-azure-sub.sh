#!/bin/bash

#==============================================================================
# Azure Subscription Cleanup Script
#==============================================================================
# Description: Automates the deletion of all resource groups in Azure
#              subscription(s) with safety confirmations and progress tracking.
# Author:      Demir Senturk
# License:     MIT
# Version:     1.0.0
#==============================================================================

set -o errexit   # Exit on error
set -o pipefail  # Exit on pipe failure
set -o nounset   # Exit on undefined variable

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_NAME=$(basename "$0")

# Options
DRY_RUN=false
VERBOSE=false

# Options
DRY_RUN=false
VERBOSE=false

#------------------------------------------------------------------------------
# Color codes for output (optional, works in most terminals)
#------------------------------------------------------------------------------
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

#------------------------------------------------------------------------------
# Logging functions
#------------------------------------------------------------------------------
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

#------------------------------------------------------------------------------
# Function: show_usage
# Description: Displays usage information
#------------------------------------------------------------------------------
show_usage() {
  cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] [SUBSCRIPTION_ID]

Clean up all resource groups in Azure subscription(s).

OPTIONS:
  -h, --help          Show this help message and exit
  -v, --version       Show version information
  -d, --dry-run       Preview what would be deleted without actually deleting
  --verbose           Enable verbose output for debugging

ARGUMENTS:
  SUBSCRIPTION_ID     (Optional) Specific Azure subscription ID to clean up
                      If omitted, ALL enabled subscriptions will be processed

EXAMPLES:
  # Clean up a specific subscription
  $SCRIPT_NAME 12345678-1234-1234-1234-123456789012

  # Preview what would be deleted (dry-run)
  $SCRIPT_NAME --dry-run 12345678-1234-1234-1234-123456789012

  # Clean up all subscriptions
  $SCRIPT_NAME

  # Show help
  $SCRIPT_NAME --help

For more information, visit:
https://github.com/demirsenturk/azure-subscription-cleanup

EOF
}

#------------------------------------------------------------------------------
# Function: show_version
# Description: Displays version information
#------------------------------------------------------------------------------
show_version() {
  echo "Azure Subscription Cleanup Script v$SCRIPT_VERSION"
  echo "Copyright (c) 2025 Demir Senturk"
  echo "License: MIT"
}

#------------------------------------------------------------------------------
# Function: validate_subscription_id
# Description: Validates Azure subscription ID format (GUID)
# Arguments:
#   $1 - Subscription ID to validate
# Returns:
#   0 if valid, 1 if invalid
#------------------------------------------------------------------------------
validate_subscription_id() {
  local sub_id=$1
  local uuid_regex='^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
  
  if [[ $sub_id =~ $uuid_regex ]]; then
    return 0
  else
    return 1
  fi
}

#------------------------------------------------------------------------------
# Function: check_azure_cli
# Description: Verifies that Azure CLI is installed and user is authenticated
#------------------------------------------------------------------------------
check_azure_cli() {
  if ! command -v az &> /dev/null; then
    log_error "Azure CLI is not installed or not in PATH"
    log_info "Install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
  fi

  # Check if user is logged in
  if ! az account show &> /dev/null; then
    log_error "Not logged in to Azure CLI"
    log_info "Please run 'az login' first"
    exit 1
  fi
}

#------------------------------------------------------------------------------
# Function: cleanup_subscription
# Description: Cleans up all resource groups in a single subscription
# Arguments:
#   $1 - Subscription ID
#   $2 - Subscription Name
#------------------------------------------------------------------------------
cleanup_subscription() {
  local SUBSCRIPTION_ID=$1
  local SUBSCRIPTION_NAME=$2
  local RESOURCE_GROUPS
  local RG
  local DELETE_COUNT=0
  
  echo ""
  echo "=================================================="
  log_info "Processing subscription: $SUBSCRIPTION_NAME"
  log_info "Subscription ID: $SUBSCRIPTION_ID"
  echo "=================================================="
  
  # Set the specified subscription
  if ! az account set --subscription "$SUBSCRIPTION_ID" 2>/dev/null; then
    log_error "Failed to set subscription: $SUBSCRIPTION_ID"
    return 1
  fi
  
  # Get the list of all resource groups in the subscription
  log_info "Fetching resource groups..."
  if ! RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv 2>/dev/null); then
    log_error "Failed to list resource groups in subscription: $SUBSCRIPTION_NAME"
    return 1
  fi
  
  if [ -z "$RESOURCE_GROUPS" ]; then
    log_warning "No resource groups found in subscription: $SUBSCRIPTION_NAME"
    return 0
  fi
  
  # Count and display resource groups
  DELETE_COUNT=$(echo "$RESOURCE_GROUPS" | wc -l)
  log_info "Found $DELETE_COUNT resource group(s):"
  for RG in $RESOURCE_GROUPS; do
    echo "  - $RG"
  done
  
  echo ""
  
  if [ "$DRY_RUN" = true ]; then
    log_warning "DRY-RUN MODE: The following $DELETE_COUNT resource group(s) would be deleted:"
    for RG in $RESOURCE_GROUPS; do
      echo "  [WOULD DELETE] $RG"
    done
    echo ""
    log_info "No actual deletions performed (dry-run mode)"
    return 0
  fi
  
  log_info "Starting deletion of $DELETE_COUNT resource group(s)..."
  
  # Loop through each resource group and delete it
  for RG in $RESOURCE_GROUPS; do
    log_info "Deleting resource group: $RG"
    if az group delete --name "$RG" --yes --no-wait 2>/dev/null; then
      log_success "Deletion initiated for: $RG"
    else
      log_error "Failed to delete resource group: $RG"
    fi
  done
  
  echo ""
  log_success "All resource groups in '$SUBSCRIPTION_NAME' have been scheduled for deletion"
  log_info "Monitor progress in Azure Portal: https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups"
  
  return 0
}

#------------------------------------------------------------------------------
# Function: print_header
# Description: Prints the script header with version information
#------------------------------------------------------------------------------
print_header() {
  echo ""
  echo "============================================================"
  echo "  Azure Subscription Cleanup Script v${SCRIPT_VERSION}"
  echo "============================================================"
  echo ""
}

#------------------------------------------------------------------------------
# Main Script Execution
#------------------------------------------------------------------------------
main() {
  local SUBSCRIPTION_ID=""
  
  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_usage
        exit 0
        ;;
      -v|--version)
        show_version
        exit 0
        ;;
      -d|--dry-run)
        DRY_RUN=true
        log_info "Dry-run mode enabled"
        shift
        ;;
      --verbose)
        VERBOSE=true
        log_info "Verbose mode enabled"
        shift
        ;;
      -*)
        log_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
      *)
        # Assume it's a subscription ID
        if [ -z "$SUBSCRIPTION_ID" ]; then
          SUBSCRIPTION_ID=$1
        else
          log_error "Multiple subscription IDs provided. Please provide only one."
          exit 1
        fi
        shift
        ;;
    esac
  done
  
  # Print header
  print_header
  
  if [ "$DRY_RUN" = true ]; then
    log_warning "Running in DRY-RUN mode - no resources will be deleted"
    echo ""
  fi
  
  # Check prerequisites
  log_info "Checking prerequisites..."
  check_azure_cli
  log_success "Azure CLI is ready"
  
  # Check if specific subscription ID is provided
  if [ -n "$SUBSCRIPTION_ID" ]; thenD" ]; then
    #------------------------------------------------------------------------
    # SINGLE SUBSCRIPTION MODE
    #------------------------------------------------------------------------
    local SUBSCRIPTION_NAME
    local CONFIRMATION
    
    log_info "Mode: Single Subscription Cleanup"
    
    # Validate subscription ID format
    if ! validate_subscription_id "$SUBSCRIPTION_ID"; then
      log_error "Invalid subscription ID format: $SUBSCRIPTION_ID"
      log_info "Subscription ID must be a valid GUID (e.g., 12345678-1234-1234-1234-123456789012)"
      exit 1
    fi
    
    # Set the specified subscription and get its name
    if ! az account set --subscription "$SUBSCRIPTION_ID" 2>/dev/null; then
      log_error "Failed to set subscription: $SUBSCRIPTION_ID"
      log_error "Please verify the subscription ID and your access permissions"
      exit 1
    fi
    
    if ! SUBSCRIPTION_NAME=$(az account show --query "name" -o tsv 2>/dev/null); then
      log_error "Failed to get subscription name for: $SUBSCRIPTION_ID"
      exit 1
    fi
    
    # Confirm with the user
    echo ""
    log_warning "You are about to delete ALL resource groups in the following subscription:"
    echo ""
    echo "  Subscription Name: $SUBSCRIPTION_NAME"
    echo "  Subscription ID:   $SUBSCRIPTION_ID"
    echo ""
    read -p "Are you sure you want to proceed? (y/n): " CONFIRMATION
    
    if [[ $CONFIRMATION != "y" && $CONFIRMATION != "Y" ]]; then
      log_info "Operation cancelled by user"
      exit 0
    fi
    
    cleanup_subscription "$SUBSCRIPTION_ID" "$SUBSCRIPTION_NAME"
  else
    #------------------------------------------------------------------------
    # BULK CLEANUP MODE (ALL SUBSCRIPTIONS)
    #------------------------------------------------------------------------
    local SUBSCRIPTIONS
    local SUB_COUNT
    local CONFIRMATION
    
    log_info "Mode: Bulk Cleanup (All Subscriptions)"
    log_warning "No subscription ID provided - will process ALL enabled subscriptions"
    echo ""
    
    # Get all enabled subscriptions
    log_info "Fetching all enabled subscriptions..."
    if ! SUBSCRIPTIONS=$(az account list --query "[?state=='Enabled'].{id:id,name:name}" -o tsv 2>/dev/null); then
      log_error "Failed to list subscriptions"
      exit 1
    fi
    
    if [ -z "$SUBSCRIPTIONS" ]; then
      log_error "No enabled subscriptions found"
      log_info "Please verify your Azure account has access to subscriptions"
      exit 1
    fi
    
    SUB_COUNT=$(echo "$SUBSCRIPTIONS" | wc -l)
    log_info "Found $SUB_COUNT enabled subscription(s):"
    echo ""
    echo "$SUBSCRIPTIONS" | while IFS=$'\t' read -r SUB_ID SUB_NAME; do
      echo "  - $SUB_NAME ($SUB_ID)"
    done
    
    # Strong confirmation required
    echo ""
    echo "============================================================"
    log_error "DANGER: This will delete ALL resource groups in ALL $SUB_COUNT subscription(s)!"
    echo "============================================================"
    echo ""
    read -p "Are you absolutely sure you want to proceed? Type 'DELETE ALL' to confirm: " CONFIRMATION
    
    if [[ $CONFIRMATION != "DELETE ALL" ]]; then
      log_info "Operation cancelled - confirmation text did not match"
      log_info "You must type 'DELETE ALL' exactly to confirm"
      exit 0
    fi
    
    echo ""
    log_info "Starting bulk cleanup of all subscriptions..."
    
    # Process each subscription
    local PROCESSED=0
    local FAILED=0
    
    while IFS=$'\t' read -r SUB_ID SUB_NAME; do
      if cleanup_subscription "$SUB_ID" "$SUB_NAME"; then
        ((PROCESSED++))
      else
        ((FAILED++))
        log_error "Failed to process subscription: $SUB_NAME"
      fi
    done <<< "$SUBSCRIPTIONS"
    
    # Final summary
    echo ""
    echo "============================================================"
    log_success "Bulk cleanup completed"
    echo "============================================================"
    log_info "Subscriptions processed: $PROCESSED"
    if [ $FAILED -gt 0 ]; then
      log_warning "Subscriptions failed: $FAILED"
    fi
    log_info "All resource groups have been scheduled for deletion"
    log_info "Monitor progress: https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups"
    echo "============================================================"
  fi
}

# Execute main function with all arguments
main "$@"