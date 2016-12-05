class getssl::global (
  $base_dir                  = $getssl::base_dir,
  $staging_ca                = $getssl::params::staging_ca,
  $prod_ca                   = $getssl::params::prod_ca,
  $production                = $getssl::params::production,
  $domain                    = undef,
  $sub_domains               = [],
  $use_single_acl            = $getssl::params::use_single_acl,
  $domain_account_mail       = $getssl::params::domain_account_mail,
  $domain_account_key_length = $getssl::params::domain_account_key_length,
  $domain_private_key_alg    = $getssl::params::domain_private_key_alg,
  $domain_reload_command     = $getssl::params::domain_reload_command,
  $domain_renew_allow        = $getssl::params::domain_renew_allow,
  $domain_server_type        = $getssl::params::domain_server_type,
  $domain_check_remote       = $getssl::params::domain_check_remote,
  $domain_cert_location      = $getssl::params::domain_cert_location,
  $domain_key_location       = $getssl::params::domain_key_location,
  $ca_cert_location          = $getssl::params::ca_cert_location,
  $domain_chain_location     = $getssl::params::domain_chain_location,
  $domain_key_cert_location  = $getssl::params::domain_key_cert_location,
  $domain_pem_location       = $getssl::params::domain_pem_location,
) inherits getssl::params {
  # Use production api of letsencrypt if $production is true
  if $production {
    $domain_ca = $prod_ca
  } else {
    $ca = $staging_ca
  }

  if $domain_account_mail {
    validate_string($domain_account_mail)
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
