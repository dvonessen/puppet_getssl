# == Class: getssl:domain
#
#   This class configures the getssl domain part.
#   Use this class to configure your specific domains.
#
#   Additionally this class calls getssl script to obtain the domain certificates
#   and installs the appropriate cronjobs to ensure all certificates will be renewed
#   at the right time spot.
#
#
#   Parameters:
#   [*base_dir*]
#     Sets the base directory for getssl. Defaults to /opt/getssl
#   [*production*]
#     BOOL. If true: call production server of Letsencrypt.
#     If false: script calls staging server. Default false.
#   [*prod_ca*]
#     Production CA of Letsencrypt.
#   [*staging_ca*]
#     Staging CA fo Letsencrypt.
#   [*domain*]
#     - Used to create configuration folder and initial configuration
#     file for getssl. Defaults to undef. Must be set.
#   [*acl*]
#     Sets ACME Chalenge Location directory. Empty array by default
#   [*use_single_acl*]
#     Bool if true: only one acl directory must be specified. 
#     If false: for each subdomain on acl. Default true.
#   [*sub_domains*]
#     Array with all subdomains for specified certificate. Defaults to empty Array.
#   [*domain_private_key_alg*]
#     Sets Key Algorythm. Defaults to rsa
#   [*domain_account_key_length*]
#     Key length for ssl certificates. Defaults to 4096
#   [*domain_account_mail*]
#     Email for registration account. Defaults to undef
#   [*domain_check_remote*]
#     BOOL checks if certificate is available and online. Defaults to global configuration.
#   [*domain_reload_command*]
#     Set command to reload e.g Webserver. Defaults to Global Command
#   [*domain_renew_allow*]
#     Integer sets interval of certificate renewal. Default 30 days before expiration.
#   [*domain_server_type*]
#     Sets servertype to check e.g HTTPs. Default https
#   [*ca_cert_location*]
#     Configures location for Certificate Authority File. Defaults to undef
#   [*domain_cert_location*]
#     Configures certifacte location. Defaults to undef.
#   [*domain_chain_location*]
#     Configures chain file location. Defaults to undef.
#   [*domain_key_cert_location*]
#     Configures Key-Cert file location. Defaults to undef.
#   [*domain_key_location*]
#     Configures Key file location. Defaults to undef.
#   [*domain_pem_location*]
#     Configures Pem file location. Defaults to undef.
#
#  Sample Usage:
#    getssl::domain { 'example.org':
#      production  => true,
#      acl         => ['/var/www/default/.well-known']
#      sub_domains => ['www.example.org', 'foo.example.org', 'bar.example.org']
#    }
#
define getssl::domain (
  $base_dir                  = $getssl::base_dir,
  $production                = $getssl::params::production,
  $prod_ca                   = $getssl::params::prod_ca,
  $staging_ca                = $getssl::params::staging_ca,
  $domain                    = $name,
  $acl                       = $getssl::params::acl,
  $use_single_acl            = $getssl::params::use_single_acl,
  $sub_domains               = $getssl::params::sub_domains,
  $domain_private_key_alg    = $getssl::params::domain_private_key_alg,
  $domain_account_key_length = $getssl::params::domain_account_key_length,
  $domain_account_mail       = $getssl::params::domain_account_mail,
  $domain_check_remote       = $getssl::params::domain_check_remote,
  $domain_reload_command     = $getssl::params::domain_reload_command,
  $domain_renew_allow        = $getssl::params::domain_renew_allow,
  $domain_server_type        = $getssl::params::domain_server_type,
  $ca_cert_location          = $getssl::params::ca_cert_location,
  $domain_cert_location      = $getssl::params::domain_cert_location,
  $domain_chain_location     = $getssl::params::domain_chain_location,
  $domain_key_cert_location  = $getssl::params::domain_key_cert_location,
  $domain_key_location       = $getssl::params::domain_key_location,
  $domain_pem_location       = $getssl::params::domain_pem_location,
) {

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

  exec { "${base_dir}/getssl -w ${base_dir}/conf -q ${domain}":
    path        => [$base_dir],
    subscribe   => File["${base_dir}/conf/${domain}/getssl.cfg"],
    refreshonly => true,
  }
}
