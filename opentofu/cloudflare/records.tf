resource "cloudflare_dns_record" "affogato_a" {
  for_each = toset(local.subdomains)

  zone_id = local.zone_id
  name    = "${each.key}.anish.land"
  type    = "A"
  content = local.affogato_ipv4
  ttl     = 300
  proxied = false
}

resource "cloudflare_dns_record" "affogato_aaaa" {
  for_each = toset(local.subdomains)

  zone_id = local.zone_id
  name    = "${each.key}.anish.land"
  type    = "AAAA"
  content = local.affogato_ipv6
  ttl     = 300
  proxied = false
}

resource "cloudflare_dns_record" "tunnel_cname" {
  for_each = toset(local.tunnel_subdomains)

  zone_id = local.zone_id
  name    = "${each.key}.anish.land"
  type    = "CNAME"
  content = "${var.tunnel_id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}
