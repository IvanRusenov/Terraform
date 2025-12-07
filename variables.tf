variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the app service plan"
  type        = string
}

variable "web_app_name" {
  description = "The name of the app service"
  type        = string
}

variable "sql_server_name" {
  description = "The name of the sql server"
  type        = string
}

variable "sql_database_name" {
  description = "The name of the database"
  type        = string
}

variable "database_collation" {
  description = "The Collation of the database"
  type        = string
}

variable "sql_admin_login" {
  description = "The admin username"
}

variable "sql_admin_login_password" {
  description = "The admin password"
  type        = string
  sensitive   = true
}

variable "firewall_rule_name" {
  description = "The name of the SQL Server firewall rule"
  type        = string
}

variable "source_control_url" {
  description = "The url of the github repo"
  type        = string
}

variable "subscription_id" {
  description = "The id of the azure account"
  type        = string
}

variable "os_type" {
  description = "The type of operating system"
  type        = string
}

variable "service_plan_sku_name" {
  description = "The service plan sku name"
  type        = string
}

variable "database_sku_name" {
  description = "The database sku name"
  type        = string
}

variable "database_storage_account_type" {
  description = "The type of storage account(Local)"
  type        = string
}

