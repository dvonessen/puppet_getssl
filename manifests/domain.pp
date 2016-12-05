class getssl::global (
  $production                = $getssl::params::production,
  $base_dir                  = $getssl::params::base_dir,
  $global_account_mail       = $getssl::params::global_account_mail,
  $global_account_key_length = $getssl::params::global_account_key_length,
  $global_private_key_alg    = $getssl::params::global_private_key_alg,
  $global_reload_command     = $getssl::params::global_reload_command,
  $global_reuse_private_key  = $getssl::params::global_reuse_private_key,
  $global_renew_allow        = $getssl::params::global_renew_allow,
  $global_server_type        = $getssl::params::global_server_type,
  $global_check_remote       = $getssl::params::global_check_remote,
  $global_ssl_conf           = $getssl::params::global_ssl_conf,
  $domain_hash               = $getssl::params::domain_hash,
) {
  # Use production api of letsencrypt if $production is true
  if $domain_production {
    $domain_ca = 'https://acme-v01.api.letsencrypt.org'
  } else {
    $domain_ca = 'https://acme-staging.api.letsencrypt.org'
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
