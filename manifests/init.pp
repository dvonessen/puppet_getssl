# Class: getssl
# ===========================
#
# This is the default init.pp class. This Class installs getssl
# and ensures that sufficient directories and files are createt.
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
  $base_dir        = $getssl::params::base_dir,
  $manage_packages = $getssl::params::manage_packages,
  $packages        = $getssl::params::packages,
) inherits getssl::params {

  # Check all variables
  validate_string($base_dir)
  validate_bool($manage_packages)
  validate_array($packages)

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
