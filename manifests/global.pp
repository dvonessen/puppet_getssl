# == Class: getssl::global
#
#   This class configures getssl's global configuration file
#   Use this class to configure global settings and preferences for your getssl environment
#
class getssl::global (
  $base_dir                  = $getssl::base_dir,
  $production                = $getssl::params::production,
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

  # Check all variables
  validate_string($global_ssl_conf, $global_server_type, $global_reload_command)
  validate_integer($global_account_key_length)
  validate_integer($global_renew_allow)
  validate_bool($production, $global_reuse_private_key, $global_check_remote)

  # Use production api of letsencrypt if $production is true
  if $production {
    $global_ca = 'https://acme-v01.api.letsencrypt.org'
  } else {
    $global_ca = 'https://acme-staging.api.letsencrypt.org'
  }

  if $global_account_mail {
    validate_string($global_account_mail)
  }

  file { "${base_dir}/conf/getssl.cfg":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
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
