terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.55.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "random_integer" "ri" {
  min = 50000
  max = 90000
}

resource "azurerm_resource_group" "tbrg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.resource_group_location
}
resource "azurerm_service_plan" "asp" {
  name                = "${var.app_service_plan_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.tbrg.name
  location            = azurerm_resource_group.tbrg.location
  os_type             = var.os_type
  sku_name            = var.service_plan_sku_name
}


resource "azurerm_mssql_server" "tbs" {
  name                         = "${var.sql_server_name}${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.tbrg.name
  location                     = azurerm_resource_group.tbrg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_login_password
}

resource "azurerm_mssql_database" "tbdb" {
  name                 = "${var.sql_database_name}${random_integer.ri.result}"
  server_id            = azurerm_mssql_server.tbs.id
  collation            = var.database_collation
  license_type         = "LicenseIncluded"
  max_size_gb          = 2
  sku_name             = var.database_sku_name
  storage_account_type = var.database_storage_account_type

  lifecycle {
    prevent_destroy = false
  }
}


resource "azurerm_linux_web_app" "taskapp" {
  name                = "${var.web_app_name}${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.tbrg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = var.web_app_database_connection_string
  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_app_service_source_control" "github_repo" {
  app_id                 = azurerm_linux_web_app.taskapp.id
  repo_url               = var.source_control_url
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_firewall_rule" "fr" {
  name             = "${var.firewall_rule_name}${random_integer.ri.result}"
  server_id        = azurerm_mssql_server.tbs.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}