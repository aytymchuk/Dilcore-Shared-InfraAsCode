terraform {
  backend "azurerm" {
    resource_group_name  = "common"
    storage_account_name = "dilcoreterraform"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}
