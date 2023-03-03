# main.tf

resource "azuread_user" "trainer" {
  user_principle_name = var.trainer-name
  display_name = "I.Ozbekler"
  mail_nickname = "IOzbekler"
  password = var.trainer-password-init
  # disable_password_expiration = false # already the default value
  # disable_strong_password = false # already the default value
  force_password_change = true
  depends_on = [azurerm_resource_group.azure-rg]
}

resource "azuread_user" "project-owner" {
  user_principle_name = var.my-name
  display_name = "J.Deng"
  mail_nickname = "JDeng"
  password = "SecretD@1s4fvw"
  depends_on = [azurerm_resource_group.azure-rg]
}

resource "aws_iam_user" "teammates" {
  for_each = toset(var.classmates-name) {
  name = each.value
  path = "/system/${each.value}"
  }
  tag = {
    tag-key = "tag-value"
  }
  depends_on = [aws_s3_bucket.aws_s3_b]
}

resource "aws_s3_bucket" "aws_s3_b" {
  count = var.s3-bucket-number
  bucket = "my-terraform-test-s3-bucket-${count.index}"
  tags = {
    Name = "My Terraform S3 buckets"
    Environment = "Prod"
  }
  depends_on = [azuread_user.project-owner, azuread_user.trainer]
}

resource "azurerm_resource_group" "azure-rg" {
  name = "RG01" # the name shown on the Azure Portal
  location = "US East"
  tags = {
    Department = "Test"
  }
  # id can be exported
}

# this resource is used to support the creation of the virtual machine in Azure
resource "azurerm_virtual_network" "azure-vn" {
  name                = "azure-vn-for-vm"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure-rg.location
  resource_group_name = azurerm_resource_group.azure-rg.name
}

# this resource is used to support the creation of the virtual machine in Azure
resource "azurerm_subnet" "azure-sbnet" {
  name                 = "azure-sbnet-for-vm"
  resource_group_name  = azurerm_resource_group.azure-rg.name
  virtual_network_name = azurerm_virtual_network.azure-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

# this resource is used to support the creation of the virtual machine in Azure
resource "azurerm_network_interface" "azure-ni" {
  name                = "azure-ni-for-vm"
  location            = azurerm_resource_group.azure-rg.location
  resource_group_name = azurerm_resource_group.azure-rg.name

  ip_configuration {
    name                          = "azure-ni-for-vm-ip-config"
    subnet_id                     = azurerm_subnet.azure-sbnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "azure-vm" {
  name = "azure-VM01" # the name shown on the Azure Portal
  location = azurerm_resource_group.azure-rg.location
  resource_group_name = azurerm_resource_group.azure-rg.name
  network_interface_id = [azurerm_network_interface.azure-ni.id]
  vm_size = "Standard_DS1_v2"
  depends_on = [azurerm_storage_account.azure-sa]
  # id can be exported
}

resource "azurerm_storage_account" "azure-sa" {
  name                     = "terraform-test-azure-storage-account"
  resource_group_name      = azurerm_resource_group.azure-rg.name
  location                 = azurerm_resource_group.azure-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  network_rules {
  default_action = "Deny"
  ip_rules = ["100.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.azure-sbnet.id]
  }

  tags = {
    environment = "staging"
  }
  depends_on = [aws_iam_user.teammates]
  # id, primary_location, secondary_location can be exported
}