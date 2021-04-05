variable cluster_name {
    default = "aks-demo-we01"
}
variable resource_group_name {
    default = "rg-aks-demo-we01"
}
variable location {
    default = "West Europe"
}
variable "client_id" {
    default = "c31f2ed4-8985-46f9-844c-8f1a93351d73"
}
variable "client_secret" {
    default = "VEWEC99UX.7D1bizP.h8jwe~GE~L.qCYJR"
}
variable "agent_count" {
    default = 1
}
variable "dns_prefix" {
    default = "aks-demo"
}
variable "vm_size" {
    default = "Standard_D2_v3"
}
variable "load_balancer_sku" {
    default = "Standard"
}
variable "network_plugin" {
    default = "kubenet"
}



