class getssl::params{
  $base_dir                  = '/opt/getssl'
  $production                = false
  $global_account_mail       = undef
  $global_account_key_length = 4096
  $global_private_key_alg    = 'rsa'
  $global_reload_command     = undef
  $global_reuse_private_key  = true
  $global_renew_allow        = 30
  $global_server_type        = 'https'
  $global_check_remote       = true
  $global_ssl_conf           = "/usr/lib/ssl/openssl.cnf"
  $manage_packages           = false
  $packages                  = ['curl']

  if $manage_packages {
    package { $packages:
      ensure => latest,
    }
  }
}
