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
) {

  # Use production api of letsencrypt if $production is true
  if $production {
    $global_ca = 'https://acme-v01.api.letsencrypt.org'
  } else {
    $global_ca = 'https://acme-staging.api.letsencrypt.org'
  }

  if $global_account_mail {
    validate_string($global_account_mail)
  } else {
    fail('$global_account_mail: undef, please configure global mail address')
  }

  file { "$base_dir/conf/getssl.cfg":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => epp('puppet:///templates/global_getssl.cfg.epp', {
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
