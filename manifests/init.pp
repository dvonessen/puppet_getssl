# Class: getssl
# ===========================
#
# This is the default init.pp class. This Class installs getssl
# and ensures that sufficient directories and files are createt.
# 
# Adds a cronjob to ensure all your certificates are updated properly
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'getssl':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <github@thielking-vonessen.de>

class getssl (
  $base_dir           = $getssl::params::base_dir,
  $manage_packages    = $getssl::params::manage_packages,
  $packages           = $getssl::params::packages,
  $production         = $getssl::params::production,
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
    $ca = 'https://acme-v01.api.letsencrypt.org'
  } else {
    $ca = 'https://acme-staging.api.letsencrypt.org'
  }

  if $account_mail {
    validate_string($account_mail)
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

  if $manage_packages {
    package { $packages:
      ensure => latest,
    }
  }

  # Create Directories under /opt
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
}
