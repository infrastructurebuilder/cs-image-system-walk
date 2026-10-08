# Lookup of Okta user mykel.alvis by login
data "okta_user" "mykel_alvis" {
  provider    = okta.okta_users
  skip_roles  = true
  skip_groups = true

  search {
    name       = "profile.login"
    value      = local.sensitive["email_mykel_alvis"]
    comparison = "eq"
  }
}
# Lookup of Okta user zachary.wills by login
data "okta_user" "zachary_wills" {
  provider    = okta.okta_users
  skip_roles  = true
  skip_groups = true

  search {
    name       = "profile.login"
    value      = local.sensitive["email_zachary_wills"]
    comparison = "eq"
  }
}