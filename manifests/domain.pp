# == Class: getssl:domain
#
#   This class configures the getssl domain part.
#   Use this class to configure your specific domains.
#
#   Additionally this class calls getssl script to obtain the domain certificates
#   and installs the appropriate cronjobs to ensure all certificates will be renewed
#   at the right time spot.
#
class getssl::domain (
  $base_dir                  = $getssl::base_dir,
  $ca_cert_location          = $getssl::params::ca_cert_location,
  $domain                    = $getssl::params::domain,
  $acl                       = $getssl::params::acl,
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
  $sub_domains               = $getssl::params::sub_domains,
  $use_single_acl            = $getssl::params::use_single_acl,
) inherits getssl::params {

  validate_string($domain_private_key_alg, $domain_server_type)
  validate_integer($domain_account_key_length)
  validate_integer($domain_renew_allow)
  validate_bool($domain_check_remote, $use_single_acl)

  if $ca_cert_location {
    validate_string($ca_cert_location)
  }

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

  if $sub_domains {
    validate_array($sub_domains)
  }

  if $acl and size($acl) > 0 {
    validate_array($acl)
  } else {
    fail('You have to set acl in your manifest!')
  }

  # Use production api of letsencrypt only if $production is true
  if $production {
    $ca = $prod_ca
  } else {
    $ca = $staging_ca
  }

  if !$domain {
    fail('$domain must be set')
  } else {
    validate_string($domain)
  }

  if $domain_account_mail {
    validate_string($domain_account_mail)
  } else {
    fail('$domain_account_mail must be set')
  }

  file { "${base_dir}/conf/${domain}":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { "${base_dir}/conf/${domain}/getssl.cfg":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('getssl/domain_getssl.cfg.epp', {
      'acl'                       => $acl,
      'base_dir'                  => $base_dir,
      'ca'                        => $ca,
      'ca_cert_location'          => $ca_cert_location,
      'domain'                    => $domain,
      'domain_account_key_length' => $domain_account_key_length,
      'domain_account_mail'       => $domain_account_mail,
      'domain_cert_location'      => $domain_cert_location,
      'domain_chain_location'     => $domain_chain_location,
      'domain_check_remote'       => $domain_check_remote,
      'domain_key_cert_location'  => $domain_key_cert_location,
      'domain_key_location'       => $domain_key_location,
      'domain_pem_location'       => $domain_pem_location,
      'domain_private_key_alg'    => $domain_private_key_alg,
      'domain_reload_command'     => $domain_reload_command,
      'domain_renew_allow'        => $domain_renew_allow,
      'domain_server_type'        => $domain_server_type,
      'sub_domains'               => $sub_domains,
      'use_single_acl'            => $use_single_acl
    }),
  }
}
