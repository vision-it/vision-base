# Class: vision_base::puppet
# ===========================
#
# Manages Puppet and its configuration
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_base::puppet
#

class vision_base::puppet (

  String $environment,
  String $repo_key,
  String $repo_key_id,

) {

  apt::source { 'puppetlabs':
    location => 'https://apt.puppetlabs.com',
    repos    => 'puppet6',
    key      => {
      id      => $repo_key_id,
      content => $repo_key,
    },
    include  => {
      'src' => false,
      'deb' => true,
    }
  }

  package { 'puppet-agent':
    ensure  => present,
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/hiera.yaml'),
    require => Package['puppet-agent'],
  }

  file { '/etc/puppetlabs/puppet/puppet.conf':
    ensure  => present,
    mode    => '0644',
    content => template('vision_base/puppet.conf.erb'),
    require => Package['puppet-agent'],
  }

  file { '/etc/puppetlabs/puppet/site.pp':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/site.pp'),
    require => Package['puppet-agent'],
  }

  # TODO: Puppet Apply Timer

}
