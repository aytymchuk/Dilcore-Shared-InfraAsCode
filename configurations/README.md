# Configuration As Code (CaC) - Deployment System

This folder contains the centralized Configuration As Code system used to deploy application settings and feature flags to Azure App Configuration.

## 🏛️ Architecture

The system uses a unified Terraform module located at the root of this folder to process configurations for all components (e.g., `platform`, `shared`).

```text
configurations/
├── main.tf                       # Centralized Terraform logic
├── variables.tf                  # Required variables (Env, Component, ID)
├── providers.tf                  # Azure Provider config
├── backend.tf                    # Remote State storage
│
├── shared/                       # Shared global configurations
│   └── environments/
│       └── development/
│           └── appsettings.json  # Regular settings
│
└── platform/                     # Component-specific configurations
    └── environments/
        └── development/
            ├── appsettings.json
            └── flags.json        # Official Azure Feature Flags
```

## 🔧 How it Works

### 1. Unified Terraform Logic
The `main.tf` dynamically loads JSON files based on the `componentName` and `env_name` variables. It flattens nested JSON structures into colon-separated keys (e.g., `Dilcore:Logging:Level`) and deploys them to Azure.

### 2. Feature Flags vs. Application Settings
The system distinguishes resources by filename:
- **`flags.json`**: Any key defined here is deployed as an **official Azure Feature Flag**, visible in the "Feature Manager" section of the Azure Portal.
- **Other `.json` files**: Deployed as regular **Configuration Keys**.

### 3. Simplified JSON Structure
Feature flags no longer require a `FeatureManagement` wrapper. Define them directly:
```json
{
  "Dilcore.Platform.WebApi": {
    "NewDashboard": true
  }
}
```

## 🚀 Deployment Pipeline

Deployment is handled via GitHub Actions using the `config-template.yml` workflow.

### Variable Replacement
The pipeline supports environment variable placeholders like `$(MY_SECRET)`. 
- Before Terraform runs, the pipeline scans `.json`, `.tf`, and `.tfvars` files in the environment folder.
- It replaces placeholders with values retrieved from the shared Azure App Configuration store.

## 🛠️ Adding a New Component

1. Create a new folder under `configurations/` (e.g., `configurations/my-new-service`).
2. Add an `environments/` directory.
3. Add environment folders (e.g., `development`, `production`).
4. Add your `appsettings.json` and `flags.json` files.
5. Create a GitHub Actions workflow that calls the `config-template.yml` with your new component name.

## ✅ Verification

To verify the Terraform configuration locally:
```bash
cd configurations
terraform init -backend=false
terraform validate
```
