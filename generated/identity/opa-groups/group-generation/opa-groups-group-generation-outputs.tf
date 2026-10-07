# Outputs of the identity root opa-groups (DESIGN N7).
# GIDs are never literals: the oktapam provider exposes no group gid, so this
# root asks the system's own CLI (read-only, credentials from the environment)
# and publishes the answer as an output for terraform_remote_state consumers.
# gid shim: {group: gid} for every managed group
data "external" "group_gids" {
  provider = external.opa_groups
  depends_on = [
    module.group_walk_team,
  ]
  program = [
    "cs-image-system",
    "identity",
    "export-gids",
  ]
  query = {
    identity_type = "okta",
    org           = "noaa",
    team          = "nos-coastal-modeling-cloud-sandbox",
    api_host      = "https://noaa.pam.okta.com",
    groups        = "walk_team",
  }
}
output "group_gids" {
  value       = { for g, gid in data.external.group_gids.result : g => tonumber(gid) }
  description = "Group name -> unix gid, queried from OPA; consume by reference only"
}
output "groups" {
  value = {
    walk_team = {
      user_group_id     = module.group_walk_team.user_group_id,
      admin_group_id    = module.group_walk_team.admin_group_id,
      resource_group_id = module.group_walk_team.resource_group_id,
      user_group_name   = module.group_walk_team.user_group_name,
    },
  }
  description = "Managed OPA groups and their object ids"
}
output "group_enrollment_tokens" {
  value = {
    walk_team = module.group_walk_team.enrollment_token,
  }
  description = "Group -> launch enrollment token (IaC-owned, PLAN.md); consume by reference only"
  sensitive   = true
}