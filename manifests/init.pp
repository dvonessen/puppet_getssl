# Class: getssl
# ===========================
#
# Full description of class getssl here.
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
  $base_dir                  = $getssl::params::base_dir,
  $production                = $getssl::params::production,
  $global_account_mail       = $getssl::params::global_account_mail,
  $global_account_key_length = $getssl::params::global_account_key_length,
  $global_agreement          = $getssl::params::global_agreement,
  $global_reload_command     = $getssl::params::global_reload_command,
  $global_reuse_private_key  = $getssl::params::global_reuse_private_key,
  $global_renew_allow        = $getssl::params::global_renew_allow,
  $global_server_type        = $getssl::params::global_server_type,
  $global_check_remote       = $getssl::params::global_check_remote,
  $global_ssl_conf           = $getssl::params::global_ssl_conf,
) inherits getssl::params {

  # Check all variables
  validate_string($base_dir, $global_ssl_conf, $global_server_type)
  validate_integer($global_account_key_length, $global_renew_allow)
  validate_bool($production, $global_reuse_private_key, $global_check_remote, $manage_packages)
  validate_array($packages)
  validate_hash()

  if $global_account_mail {
    validate_string($global_account_mail)
  } else {
    fail('$global_account_mail: undef, please configure global mail address')
  }



  # Create Directories under /opt
  file { $base_dir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  file { "${base_dir}/conf":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  file { "${base_dir}/getssl":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0700',
    source => 'https://raw.githubusercontent.com/srvrco/getssl/master/getssl',
  }

  # Include global configuration class
  class { '::getssl::global':
    require => File["${base_dir}/getssl",
  }
}
