module "resource_group" {
  source   = "../modules/azurerm_resource_group"
  rg_name  = "404-todoapp"
  location = "Central India"
}

module "resource_group1" {
  source   = "../modules/azurerm_resource_group"
  rg_name  = "4044-todoapp"
  location = "West US"
}

module "virtual_network" {
  depends_on    = [module.resource_group]
  source        = "../modules/azurerm_virtual_network"
  vnet_name     = "vnet-todoapp"
  location      = "Central India"
  rg_name       = "404-todoapp"
  address_space = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  subnet_name          = "frontend-subnet"
  rg_name              = "404-todoapp"
  virtual_network_name = "vnet-todoapp"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  subnet_name          = "backend-subnet"
  rg_name              = "404-todoapp"
  virtual_network_name = "vnet-todoapp"
  address_prefixes     = ["10.0.2.0/24"]
}

module "public-ip_frontend" {
  depends_on        = [module.resource_group]
  source            = "../modules/azurerm_public_ip"
  pip_name          = "pip-todoapp-frontend"
  rg_name           = "404-todoapp"
  location          = "Central India"
  allocation_method = "Static"

}

module "public-ip_backend" {
  depends_on        = [module.resource_group]
  source            = "../modules/azurerm_public_ip"
  pip_name          = "pip-todoapp-backend"
  rg_name           = "404-todoapp"
  location          = "Central India"
  allocation_method = "Static"

}

module "frontend_vm" {
  depends_on = [module.frontend_subnet, module.public-ip_frontend, module.key_vault, module.vm_username, module.vm_password]
  source     = "../modules/azurerm_virtual_machine"

  rg_name         = "404-todoapp"
  location        = "Central India"
  vm_name         = "vm-frontend"
  vm_size         = "Standard_B1s"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "18.04-LTS"
  image_version   = "latest"
  nic_name        = "nic-vm-frontend"
  # subnet_id        = data.azurerm_subnet.subnet.id
  # Data Block
  virtual_network_name = "vnet-todoapp"
  subnet_name          = "frontend-subnet"
  pip_name             = "pip-todoapp-frontend"
  # pipid = data.azurerm_public_ip.pip.id
  key_vault_name       = "keyvault-404"
  username_secret_name = "vm-username"
  password_secret_name = "vm-password"
}

module "backendend_vm" {
  depends_on = [module.backend_subnet, module.public-ip_backend, module.key_vault, module.vm_username, module.vm_password]
  source     = "../modules/azurerm_virtual_machine"

  rg_name         = "404-todoapp"
  location        = "Central India"
  vm_name         = "vm-backend"
  vm_size         = "Standard_B1s"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_sku       = "20_04-lts"
  image_version   = "latest"
  nic_name        = "nic-vm-backend"
  # subnet_id        = data.azurerm_subnet.subnet.id
  # Data Block
  virtual_network_name = "vnet-todoapp"
  subnet_name          = "backend-subnet"
  pip_name             = "pip-todoapp-backend"
  # pipid = data.azurerm_public_ip.pip.id
  key_vault_name       = "keyvault-404"
  username_secret_name = "vm-username"
  password_secret_name = "vm-password"
}

module "sql_server" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_sql_server"

  sql_server_name              = "404-sqlserver-todoapp"
  rg_name                      = "404-todoapp"
  location                     = "Central India"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd123456"

}

module "sql_database" {
  depends_on = [module.sql_server]
  source     = "../modules/azurerm_sql_database"

  sqldb_name      = "tododb"
  sql_server_name = "404-sqlserver-todoapp"
  rg_name         = "404-todoapp"

}

#######################################################

module "key_vault" {
  source   = "../modules/azurerm_key_vault"
  kv_name  = "keyvault-404"
  location = "Central India"
  rg_name  = "404-todoapp"

}

module "vm_username" {
  depends_on     = [module.key_vault]
  source         = "../modules/azurerm_key_vault_secret"
  key_vault_name = "keyvault-404"
  rg_name        = "404-todoapp"
  secret_name    = "vm-username"
  secret_value   = "devopsadmin"
}

module "vm_password" {
  depends_on     = [module.key_vault]
  source         = "../modules/azurerm_key_vault_secret"
  key_vault_name = "keyvault-404"
  rg_name        = "404-todoapp"
  secret_name    = "vm-password"
  secret_value   = "P@ssw0rd@123"
}

