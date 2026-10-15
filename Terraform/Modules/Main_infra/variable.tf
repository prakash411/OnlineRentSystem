variable "main-infra-object" {
  type = object({
    route53_zone_name = string
    vpc_id            = string
    vpc_region        = string
    account_id        = string
  })
}