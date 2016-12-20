# getssl

#### Table of Contents

1. [Module description](#module-description)
1. [Setup - The basics of getting started with getssl](#setup)
    * [What getssl affects](#what-getssl-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with getssl](#beginning-with-getssl)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Appendix](#appendix)

## Module description

This Module uses srvrco's getssl bash script to obtain SSL-Certificates.
The certificates can be used for various protocols like https, smtps, ldaps and so on.
To get more information about srvrco's getssl script go to his site.
[getssl](https://github.com/srvrco/getssl)

You can use this module only to install getssl script and configure it by yourself or
configure all SSL relevant parameters and let this module obtain SSL certificates for you.

## Setup

### What getssl affects

This module creates folders and files under the base directory

* The base directory is `/opt/getssl/`
* For each domain it creates new sub directory `$base_dir/example.com/`

### Setup Requirements

If you want to use this module you have to install `curl`.
If you don't want to install curl manually you can install it with this module.

### Beginning with getssl

To install getssl you only have to include it in your manifest.

``` puppet
class { 'getssl': }
```

## Usage

### Configuring global configuration file

`getssl` is modular so you can set global configuration parameters
and the local parameters will overwrite the global ones.
To configure the global configuration parameters the following code is can be
used to ensure a minimal configuration.

``` puppet
class { 'getssl':
  account_mail    => 'foo@bar.com',
  production      => true,
  manage_packages => true,
}
```
### Configure domain specific parameters

To obtain a certificate for your domain use the defined function.
Following example is for nginx. But you can yous your favorite webserver
e.g apache2 or lighttp.

``` puppet
  getssl::domain { 'example.com':
    acl                  => ['/var/nginx/default],
    sub_domains          => ['www.example.com', 'foo.example.com', 'bar.example.com'],
    domain_check_remote  => true,
    production           => true,
  }
```

This example tries to get a certificate for:
`example.com, www.example.com, foo.example.com, bar.example.com`

## Reference

### Public Classes

### Class: `getssl`

This class is used to install getssl on your server and configure the global parameters.

``` puppet
  class{ 'getssl': }
```
**Description of parameters can be found in the appropriate .pp files**

### Public defined types

The defined type `getssl::domain` is used to configure domain specific parameters. This type 
tries to obtain the certificates from letsencrypt.

**Description of parameters can be found in the appropriate .pp files**

## Limitations

This module ist testet on Debian 8 Stable. Can test it under a different version or OS please
make an issue to disscuse.

> **Note**: There are some limitations to obtain SSL certificates by LetsEncrypt themselves.
Please also read the documentation of LetsEncrypt. 
[LetsEncrpyt Documentation](https://letsencrypt.org/docs/)

## Development

If you want to make improvements open a issue or make a pull request.
I will add few tests to this module but i am new to this so it will take time.

## Appendix

A big thanks to srvrco for his perfect bash written shell script. Thank you!
Thanks to the community of LetsEncrypt.
