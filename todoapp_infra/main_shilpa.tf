resource "azurerm_key_vault_secret" "vm_password1" {
  depends_on     = [module.key_vault]
  source         = "../modules/azurerm_key_vault_secret"
  key_vault_name = "keyvault-404"
  rg_name        = "404-todoapp"
  secret_name    = "vm-password1"
  secret_value   = "P@ssw0rd@123"
}