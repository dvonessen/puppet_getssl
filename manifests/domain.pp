class getssl::global (
  $base_dir                  = $getssl::base_dir,
  $ca_cert_location          = $getssl::params::ca_cert_location,
  $domain                    = undef,
  $domain_account_key_length = $getssl::params::domain_account_key_length,
  $domain_account_mail       = $getssl::params::domain_account_mail,
  $domain_cert_location      = $getssl::params::domain_cert_location,
  $domain_chain_location     = $getssl::params::domain_chain_location,
  $domain_check_remote       = $getssl::params::domain_check_remote,
  $domain_key_cert_location  = $getssl::params::domain_key_cert_location,
  $domain_key_location       = $getssl::params::domain_key_location,
  $domain_pem_location       = $getssl::params::domain_pem_location,
  $domain_private_key_alg    = $getssl::params::domain_private_key_alg,
  $domain_reload_command     = $getssl::params::domain_reload_command,
  $domain_renew_allow        = $getssl::params::domain_renew_allow,
  $domain_server_type        = $getssl::params::domain_server_type,
  $prod_ca                   = $getssl::params::prod_ca,
  $production                = $getssl::params::production,
  $staging_ca                = $getssl::params::staging_ca,
  $sub_domains               = [],
  $use_single_acl            = $getssl::params::use_single_acl,
) inherits getssl::params {

  validate_string($domain_private_key_alg, $domain_server_type)
  validate_integer($domain_account_key_length)
  validate_integer($domain_renew_allow)
  validate_bool($domain_check_remote, $use_single_acl)
  validate_array($sub_domains)

  if $domain_cert_location {
    validate_string($domain_cert_location)
  }

  if $domain_chain_location {
    validate_string($domain_chain_location)
  }

  if $domain_key_cert_location {
    validate_string($domain_key_cert_location)
  }

  if $domain_key_location {
    validate_string($domain_key_location)
  }

  if $domain_pem_location {
    validate_string($domain_pem_location)
  }

  if $domain_reload_command {
    validate_string($domain_reload_command)
  }

  # Use production api of letsencrypt only if $production is true
  if $production {
    $domain_ca = $prod_ca
  } else {
    $ca = $staging_ca
  }

  if $domain {
    validate_string($domain)
  } else {
    fail('$domain must be set')
  }

  if $domain_account_mail {
    validate_string($domain_account_mail)
  } else {
    fail('$domain_account_mail must be set')
  }

  file { "${base_dir}/conf/{${domain}":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => "0644",
  }

  file { "${base_dir}/conf/${domain}/getssl.cfg":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => "0644",
    content => epp('getssl/global_getssl.cfg.epp', {
      'global_ca'                 => $global_ca,
      'global_account_mail'       => $global_account_mail,
      'global_account_key_length' => $global_account_key_length,
      'base_dir'                  => $base_dir,
      'global_private_key_alg'    => $global_private_key_alg,
      'global_reuse_private_key'  => $global_reuse_private_key,
      'global_reload_command'     => $global_reload_command,
      'global_renew_allow'        => $global_renew_allow,
      'global_server_type'        => $global_server_type,
      'global_check_remote'       => $global_check_remote,
      'global_ssl_conf'           => $global_ssl_conf,
    }),
  }
}
