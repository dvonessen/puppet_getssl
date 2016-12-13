# Class: getssl
# ===========================
#
# This is the default init.pp class. This Class installs getssl
# and ensures that sufficient directories and files are createt.
# 
# Adds a cronjob to ensure all your certificates are updated properly
#
# Parameters
#   [*base_dir*]
#     Base directory for getssl script and configuration. Default /opt
#   [*production*]
#     Bool if true: use production letsencrypt server.
#     If false use staging server. Default false
#   [*prod_ca*]
#     Production CA of Letsencrypt.
#   [*staging_ca*]
#     Staging CA fo Letsencrypt.
#   [*manage_packages*]
#     Bool if true: Install specified Packages. If false don't. Default false
#   [*packages*]
#     Installs sufficient Packages for getssl. Default curl
#   [*account_mail*]
#     Global Email Address for Letsencrypt registration
#   [*account_key_length*]
#     Account key length. Default 4096
#   [*account_key_alg*]
#     Account key algorythm. Default rsa
#   [*reload_command*]
#     Specifies reload for services. E.g systemctl restart apach2. Default undef
#   [*reuse_private_key*]
#     Bool if true private key is generated only once and used for each domain. Default true
#   [*renew_allow*]
#     Integer sets interval of certificate renewal. Default 30 days before expiration.
#   [*server_type*]
#     Sets server type e.g to https. Default https
#   [*check_remote*]
#     Bool. Check if certificate is correct installed. Default true
#   [*ssl_conf*]
#     Default location for openssl.cnf file. Default /usr/lib/ssl/openssl.cnf
#
# Action
# ===========================
#
#   - Installs getssl 
#   - Configure global getssl.cfg
#   - Installs cronjob for certificate renewal
#
# Examples
# --------
#
#   class { 'getssl':
#     account_mail => 'admin@example.com',
#   }
#
# Authors
# -------
#
# Author Name <github@thielking-vonessen.de>

class getssl (
  $base_dir           = $getssl::params::base_dir,
  $production         = $getssl::params::production,
  $prod_ca            = $getssl::params::prod_ca,
  $staging_ca         = $getssl::params::staging_ca,
  $manage_packages    = $getssl::params::manage_packages,
  $packages           = $getssl::params::packages,
  $account_mail       = $getssl::params::account_mail,
  $account_key_length = $getssl::params::account_key_length,
  $private_key_alg    = $getssl::params::private_key_alg,
  $reload_command     = $getssl::params::reload_command,
  $reuse_private_key  = $getssl::params::reuse_private_key,
  $renew_allow        = $getssl::params::renew_allow,
  $server_type        = $getssl::params::server_type,
  $check_remote       = $getssl::params::check_remote,
  $ssl_conf           = $getssl::params::ssl_conf,
) inherits getssl::params {

  # Check all variables
  validate_string($base_dir, $ssl_conf, $server_type, $reload_command)
  validate_bool($manage_packages, $production, $reuse_private_key, $check_remote)
  validate_array($packages)
  validate_integer($account_key_length)
  validate_integer($renew_allow)

  # Use production api of letsencrypt if $production is true
  if $production {
    $ca = $prod_ca
  } else {
    $ca = $staging_ca
  }

  if $account_mail {
    validate_string($account_mail)
  }

  # Install packages if $manage_packages is true
  if $manage_packages {
    package { $packages:
      ensure => latest,
    }
  }

  # Create Base Directories
  file { $base_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  file { "${base_dir}/conf":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  file { "${base_dir}/getssl":
    ensure => file,
    force  => true,
    owner  => root,
    group  => root,
    mode   => '0700',
    source => 'puppet:///modules/getssl/getssl.sh',
  }

  file { "${base_dir}/conf/getssl.cfg":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => epp('getssl/global_getssl.cfg.epp', {
      'ca'                 => $ca,
      'account_mail'       => $account_mail,
      'account_key_length' => $account_key_length,
      'base_dir'           => $base_dir,
      'private_key_alg'    => $private_key_alg,
      'reuse_private_key'  => $reuse_private_key,
      'reload_command'     => $reload_command,
      'renew_allow'        => $renew_allow,
      'server_type'        => $server_type,
      'check_remote'       => $check_remote,
      'ssl_conf'           => $ssl_conf,
    }),
  }

  cron { 'getssl_renew':
    ensure  => present,
    command => "${base_dir}/getssl -w ${base_dir}/conf -a -q -u",
    user    => 'root',
    hour    => '23',
    minute  => '5',
  }
}
