variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "tunnel_id" {
  description = "Cloudflare Tunnel ID for affogato"
  type        = string
}
