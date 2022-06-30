resource "azurerm_virtual_network" "codecov" {
  name                = "codecov-enterprise"
  location            = azurerm_resource_group.codecov-enterprise.location
  resource_group_name = azurerm_resource_group.codecov-enterprise.name
  address_space       = ["10.1.8.0/21"]
  tags                = var.resource_tags
}

resource "azurerm_subnet" "codecov" {
  name                 = "codecov"
  virtual_network_name = azurerm_virtual_network.codecov.name
  resource_group_name  = azurerm_resource_group.codecov-enterprise.name
  address_prefixes = [
    "10.1.8.0/21"
  ]
  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
  ]
}

resource "azurerm_route_table" "codecov" {
  name                = "codecov-routetable"
  location            = azurerm_resource_group.codecov-enterprise.location
  resource_group_name = azurerm_resource_group.codecov-enterprise.name

  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
  tags = var.resource_tags
}

resource "azurerm_subnet_route_table_association" "codecov" {
  subnet_id      = azurerm_subnet.codecov.id
  route_table_id = azurerm_route_table.codecov.id
}
