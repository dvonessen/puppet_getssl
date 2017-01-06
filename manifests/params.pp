# == Class: getssl::params
#
#   This class sets all the sufficient default settings
#
class getssl::params{
  # Main parts
  $base_dir                  = '/opt/getssl'
  $production                = false
  $prod_ca                   = 'https://acme-v01.api.letsencrypt.org'
  $staging_ca                = 'https://acme-staging.api.letsencrypt.org'
  $manage_packages           = false
  $packages                  = ['curl']

  # Configuration of global getssl config file
  $account_mail       = undef
  $account_key_length = 4096
  $private_key_alg    = 'rsa'
  $reload_command     = undef
  $reuse_private_key  = true
  $renew_allow        = 30
  $server_type        = 'https'
  $check_remote       = true
  $ssl_conf           = '/usr/lib/ssl/openssl.cnf'

  # Configuration of domain specific config file
  $domain                    = undef
  $acl                       = []
  $use_single_acl            = true
  $sub_domains               = []
  $domain_private_key_alg    = 'rsa'
  $domain_account_key_length = 4096
  $domain_account_mail       = undef
  $domain_check_remote       = true
  $domain_reload_command     = undef
  $domain_renew_allow        = 30
  $domain_server_type        = 'https'
  $ca_cert_location          = undef
  $domain_cert_location      = undef
  $domain_chain_location     = undef
  $domain_key_cert_location  = undef
  $domain_key_location       = undef
  $domain_pem_location       = undef
  # Suppress running getssl inside Puppet.  Thus, rely only on the cron job
  $suppress_getssl_run       = false
}
