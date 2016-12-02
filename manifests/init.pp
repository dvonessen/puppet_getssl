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
  $base_dir                  = '/opt/getssl',
  $production                = false,
  $global_account_mail       = undef,
  $global_account_key_length = 4096,
  $global_private_key_alg    = 'rsa',
  $global_agreement          = undef,
  $global_reload_command     = undef,
  $global_reuse_private_key  = true,
  $global_renew_allow        = 30,
  $global_server_type        = 'https',
  $global_check_remote       = true,
  $global_ssl_conf           = "/usr/lib/ssl/openssl.cnf",
) inherits params{

  # Check all variables
  validate_string($base_dir)

  # Use production api of letsencrypt if $production is true
  if $production {
    $global_ca = 'https://acme-v01.api.letsencrypt.org'
  } else {
    $global_ca = 'https://acme-staging.api.letsencrypt.org'
  }

  if $global_account_email == undef {
    fail('$global_account_mail must be specified!')
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
    require => File[$base_dir],
  }
  file { "${base_dir}/getssl":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0700',
    source => 'https://raw.githubusercontent.com/srvrco/getssl/master/getssl',
    require => File[$base_dir],
  }
}
