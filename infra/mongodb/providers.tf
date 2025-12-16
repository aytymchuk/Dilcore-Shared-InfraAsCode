# Configure the MongoDB Atlas Provider
provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
}