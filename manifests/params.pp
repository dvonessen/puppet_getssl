class getssl::params{
  # Main parts
  $base_dir                  = '/opt/getssl'
  $staging_ca                = 'https://acme-staging.api.letsencrypt.org'
  $prod_ca                   = 'https://acme-v01.api.letsencrypt.org'
  $manage_packages           = false
  $packages                  = ['curl']
  $production                = false

  # Configuration of global getssl config file
  $global_account_mail       = undef
  $global_account_key_length = 4096
  $global_private_key_alg    = 'rsa'
  $global_reload_command     = undef
  $global_reuse_private_key  = true
  $global_renew_allow        = 30
  $global_server_type        = 'https'
  $global_check_remote       = true
  $global_ssl_conf           = "/usr/lib/ssl/openssl.cnf"

  # Configuration of domain specific config file
  $domain                    = undef
  $sub_domains               = []
  $acl                       = []
  $use_single_acl            = true
  $domain_account_mail       = $global_account_mail
  $domain_account_key_length = $global_account_key_length
  $domain_private_key_alg    = $global_private_key_alg
  $domain_reload_command     = $global_reload_command
  $domain_renew_allow        = $global_renew_allow
  $domain_server_type        = $global_server_type
  $domain_check_remote       = $global_check_remote
  $domain_cert_location      = undef
  $domain_key_location       = undef
  $ca_cert_location          = undef
  $domain_chain_location     = undef
  $domain_key_cert_location  = undef
  $domain_pem_location       = undef
}
