# 🌉 azure-subscription-bridge

**Bridge Azure subscriptions using RBAC and Managed Identities**

This Terraform project demonstrates how to securely access secrets in an Azure Key Vault located in one subscription (Subscription B) from a Virtual Machine in a different subscription (Subscription A) using Azure Managed Identities and RBAC.

---

## 📌 Use Case

- A Linux VM in **Subscription A** needs to read secrets from a **Key Vault in Subscription B**.
- The VM is configured with a **System-Assigned Managed Identity**.
- Access is granted via **RBAC** on the Key Vault (no secrets or credentials stored in code).

---

## 🛠️ Tech Stack

- [Terraform](https://www.terraform.io/)
- [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/)
- Azure Managed Identities
- Azure Key Vault
- Azure RBAC (Role-Based Access Control)

---

## 🧭 Project Structure

```bash
azure-subscription-bridge/
├── vm-subscription-a/        # VM + Managed Identity
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── kv-subscription-b/        # Key Vault + Secret + RBAC
│   ├── main.tf
│   └── variables.tf
└── README.md                 # You are here
```

## 🚀 Getting Started

1. Clone the repo
2. Deploy VM (Subscription A)
    
    Set your variables
    ```bash
    cd vm-subscription-a
    export TF_VAR_location="westeurope"
    export TF_VAR_subscription_id=""
    export TF_VAR_tenant_id=""
    ```
    Deploy
    ```bash
    terraform init
    terraform apply -auto-approve
    ```

3. Deploy Key Vault (Subscription B)
    Set your variables
    ```bash
    cd vm-subscription-b
    export TF_VAR_location="westeurope"
    export TF_VAR_subscription_id=""
    export TF_VAR_tenant_id=""
    export TF_VAR_vm_identity_object_id="[Output of previous terraform run]"
    ```
    Deploy
    ```bash
    terraform init
    terraform apply -auto-approve
    ```

## ✅ Result
 - VM can now access secrets in the remote Key Vault using its Managed Identity.
 - No credentials or secrets are stored locally.
 - Fully managed and repeatable via Terraform.

## 🧪 Test It (From VM)

 ```bash
 az login --identity --allow-no-subscriptions
 az keyvault secret show --vault-name <VaultName> --name example-secret
 ```