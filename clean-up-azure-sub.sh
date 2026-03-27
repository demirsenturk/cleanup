#!/bin/bash

# Function to clean up a single subscription
cleanup_subscription() {
  local SUBSCRIPTION_ID=$1
  local SUBSCRIPTION_NAME=$2
  
  echo ""
  echo "=================================================="
  echo "Processing subscription: $SUBSCRIPTION_NAME"
  echo "Subscription ID: $SUBSCRIPTION_ID"
  echo "=================================================="
  
  # Set the specified subscription
  az account set --subscription $SUBSCRIPTION_ID
  
  # Get the list of all resource groups in the subscription
  RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)
  
  if [ -z "$RESOURCE_GROUPS" ]; then
    echo "No resource groups found in subscription: $SUBSCRIPTION_NAME"
    return
  fi
  
  echo "Found resource groups:"
  for RG in $RESOURCE_GROUPS; do
    echo "  - $RG"
  done
  
  # Loop through each resource group and delete it
  for RG in $RESOURCE_GROUPS; do
    echo "Deleting resource group: $RG"
    az group delete --name $RG --yes --no-wait
  done
  
  echo "All resource groups in $SUBSCRIPTION_NAME have been scheduled for deletion."
}

# Check if specific subscription ID is provided
if [ -n "$1" ]; then
  # Original behavior - clean up single subscription
  SUBSCRIPTION_ID=$1
  
  # Set the specified subscription
  az account set --subscription $SUBSCRIPTION_ID
  
  # Get the subscription name
  SUBSCRIPTION_NAME=$(az account show --query "name" -o tsv)
  
  # Confirm with the user
  echo "You are about to delete all resource groups in the subscription:"
  echo "Subscription Name: $SUBSCRIPTION_NAME"
  echo "Subscription ID: $SUBSCRIPTION_ID"
  read -p "Are you sure you want to proceed? (y/n): " CONFIRMATION
  
  if [[ $CONFIRMATION != "y" ]]; then
    echo "Operation cancelled."
    exit 0
  fi
  
  cleanup_subscription $SUBSCRIPTION_ID "$SUBSCRIPTION_NAME"
else
  # New behavior - clean up all subscriptions
  echo "No subscription ID provided. Will process ALL subscriptions."
  echo ""
  
  # Get all subscriptions
  SUBSCRIPTIONS=$(az account list --query "[?state=='Enabled'].{id:id,name:name}" -o tsv)
  
  if [ -z "$SUBSCRIPTIONS" ]; then
    echo "No enabled subscriptions found."
    exit 1
  fi
  
  echo "Found the following enabled subscriptions:"
  echo "$SUBSCRIPTIONS" | while IFS=$'\t' read -r SUB_ID SUB_NAME; do
    echo "  - $SUB_NAME ($SUB_ID)"
  done
  
  echo ""
  echo "WARNING: This will delete ALL resource groups in ALL of your enabled subscriptions!"
  read -p "Are you absolutely sure you want to proceed? Type 'DELETE ALL' to confirm: " CONFIRMATION
  
  if [[ $CONFIRMATION != "DELETE ALL" ]]; then
    echo "Operation cancelled. You must type 'DELETE ALL' exactly to confirm."
    exit 0
  fi
  
  echo ""
  echo "Starting cleanup of all subscriptions..."
  
  # Process each subscription
  echo "$SUBSCRIPTIONS" | while IFS=$'\t' read -r SUB_ID SUB_NAME; do
    cleanup_subscription "$SUB_ID" "$SUB_NAME"
  done
  
  echo ""
  echo "=================================================="
  echo "All subscriptions have been processed."
  echo "All resource groups have been scheduled for deletion."
  echo "=================================================="
fi