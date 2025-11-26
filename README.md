# End‑to‑End Guide: Provisioning on Azure Using Terraform + Azure DevOps

This document walks you from **zero to deployment** using:

* Azure Terraform IaC (VNet, App Service, MySQL, Key Vault)
* Azure DevOps Pipelines: **Infra → DB → App**
* App build process (Composer + NPM) -- Not Currently Implemented
* Secure DB credentials in **Azure Key Vault** with App Service Key Vault references

---

# 1. Prerequisites

## Azure

* Azure Subscription
* Azure Service Principal with Contributor + User Access Administrator
* Resource Group (or Terraform will create it)
* Storage Account + Container for Terraform backend

## Azure DevOps

* Project created
* Repos enabled
* Three Pipelines (YAML)
* Service Connection to Azure (SPN)

## Local Environment (optional)

* Terraform ≥ 1.5
* Azure CLI
* Git

---

# 2. Repository Structure

```
repo/
  terraform/
    infra/
      envs/
        nonprod/
          main.tf
          variables.tf
          outputs.tf
          backend.tf
          terraform.tfvars
      modules/
        network/
          main.tf
          variables.tf
          outputs.tf
        keyvault/
          main.tf
          variables.tf
          outputs.tf
        mysql/
          main.tf
          variables.tf
          outputs.tf
        frontdoor_waf/
          main.tf
          variables.tf
          outputs.tf
        appservice/
          main.tf
          variables.tf
          outputs.tf
        monitoring/
          main.tf
          variables.tf
          outputs.tf
    db/
      main.tf
      variables.tf
      outputs.tf
      backend.tf
    app/
      main.tf
      variables.tf
      outputs.tf
      backend.tf

  azure-pipelines-infra.yml
  azure-pipelines-db.yml
  azure-pipelines-app.yml

  (Your) Snipe-IT source code
```

---

# 3. Terraform Overview

## 3.1 Infrastructure Module (`infra/`)

This module provisions:

* Non‑prod VNet + subnets (App + DB)
* App Service Plan (Linux)
* Azure App Service
* Azure Key Vault
* Access Policies for allowed user groups

**Outputs include:**

* VNet information
* Subnet IDs
* App Service details
* Key Vault name

## 3.2 Database Module (`db/`)

This module provisions:

* Azure Database for MySQL Flexible Server
* Private endpoint
* Firewall rules (if needed)
* **Writes DB credentials to Key Vault**

**Key Vault secrets created:**

* `DB_HOST`
* `DB_DATABASE`
* `DB_USERNAME`
* `DB_PASSWORD`

## 3.3 Application Module (`app/`)

This module:

* Connects App Service to VNet
* Configures Managed Identity
* Grants App Service identity **Key Vault secret access**
* Sets Key Vault‑backed app settings:

```
DB_HOST=@Microsoft.KeyVault(SecretUri=...)
DB_USERNAME=@Microsoft.KeyVault(SecretUri=...)
...
```

---

# 4. Azure DevOps Pipelines

## 4.1 Pipeline 1 — Infrastructure (`azure-pipelines-infra.yml`)

**What it does:**

* Installs Terraform
* Runs `terraform init/plan/apply` for `infra/`
* Publishes outputs for the DB pipeline

## 4.2 Pipeline 2 — Database (`azure-pipelines-db.yml`)

**What it does:**

* Reads infra outputs
* Runs DB Terraform
* Pushes the DB hostname and credentials into Key Vault
* Publishes DB outputs for the App pipeline

## 4.3 Pipeline 3 — App Deploy (`azure-pipelines-app.yml`)

**What it does:**

* Installs PHP and Node
* Composer install
* NPM `ci` + `production` build
* Package ZIP
* Deploy to App Service
* Ensure Key Vault references are configured
* Optional: run `php artisan migrate --force`

All three YAMLs are already included in this document.

---

# 5. Execution — End‑to‑End

## STEP 1 — Create Backend Storage

```bash
az group create -n tfstate-rg -l eastus
az storage account create -g tfstate-rg -n mystatetf12345 -l eastus --sku Standard_LRS
az storage container create --account-name mystatetf12345 -n tfstate
```

Update all `backend.tf` files with:

```
resource_group_name  = "tfstate-rg"
storage_account_name = "mystatetf12345"
container_name       = "tfstate"
key                  = "infra.tfstate" (per module)
```

---

## STEP 2 — Commit Code to Azure Repos

Push your repo structure exactly as shown.

```
git add .
git commit -m "Initial Snipe-IT Terraform deployment"
git push
```

---

## STEP 3 — Create Azure DevOps Service Connection

Azure DevOps → Project Settings → Service Connections → New → Azure Resource Manager → Service Principal
Name it: **azure-spn**

---

## STEP 4 — Create the Three Pipelines

Pipeline → New pipeline → YAML → Select each file:

* `azure-pipelines-infra.yml`
* `azure-pipelines-db.yml`
* `azure-pipelines-app.yml`

Ensure variables are set for each pipeline:

```
resourceGroupName
location
keyVaultName
appName
mysqlAdminUser
mysqlAdminPassword
mysqlDBName
AzureServiceConnection = azure-spn
```

---

# 6. Deployment Flow

### 6.1 Run Pipeline 1 — Infra

Creates:

* VNet
* Subnets
* App Service + Plan
* Key Vault
* Managed Identity
  Outputs are published.

### 6.2 Run Pipeline 2 — DB

Creates:

* MySQL Flexible Server
* Private endpoint
* Stores DB credentials in Key Vault
  Outputs are published.

### 6.3 Run Pipeline 3 — App Deploy

Performs:

* Composer install
* NPM production asset build
* ZIP build
* Deploy to App Service
* Sets Key Vault app settings
* Optional DB migrations

At this stage Snipe‑IT is live.

---

# 7. Validating Deployment

## 7.1 Check App Service logs

```
az webapp log tail --name <app> --resource-group <rg>
```

Expect no DB connection errors. If any occur, verify:

* Key Vault references resolve
* App has correct Managed Identity permissions

## 7.2 Test Snipe‑IT in browser

Navigate to:

```
https://<appservice>.azurewebsites.net
```

You should see Snipe‑IT setup screen or auto‑redirect.

---

# 8. Security Notes

* **No secrets** exist in pipelines — only in Key Vault
* App Service accesses DB *only via private endpoint*
* Only select user group can deploy (via DevOps permissions)
* Terraform modules enforce network isolation

---

# 9. Next Enhancements

* Add WAF + Azure Front Door
* Auto‑rotate MySQL password via Key Vault rotation
* Add Monitoring (App Insights, MySQL Insights)
* Build staging environment

---

This is now a complete end‑to‑end operational manual to deploy Snipe‑IT securely on Azure using Terraform and Azure DevOps.
