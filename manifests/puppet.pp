# Class: vision_base::puppet
# ===========================
#
# Manages Puppet and its configuration
#
# Parameters
# ----------
#
# @param environment Name of the default Puppet environment
# @param control_path SSH path to control repository (ssh://git@...)
# @param repo_key Key of the Puppetlabs Apt repository
# @param repo_key_id Key ID of the Puppetlabs Apt repository
#
# Examples
# --------
#
# @example
# contain ::vision_base::puppet
#

class vision_base::puppet (

  String $control_path,
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
    },
    notify   => Exec['apt_update'],
  }

  package { 'puppet-agent':
    ensure  => present,
    require => Apt::Source['puppetlabs'],
  }

  # Puppet is triggered via systemd Timer
  service { 'puppet':
    ensure  => stopped,
    enable  => false,
    require => Package['puppet-agent'],
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

  # Main manifest which includes the node's role
  file { '/etc/puppetlabs/puppet/site.pp':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/site.pp'),
    require => Package['puppet-agent'],
  }

  # Puppet apply Service and Timer
  file { '/etc/systemd/system/puppet-apply.service':
    ensure  => present,
    content => file('vision_base/puppet-apply.service'),
    notify  => Service['puppet-apply.timer'],
  }

  file { '/etc/systemd/system/puppet-apply.timer':
    ensure  => present,
    content => file('vision_base/puppet-apply.timer'),
    notify  => Service['puppet-apply.timer'],
  }

  service { 'puppet-apply.timer':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      File['/etc/systemd/system/puppet-apply.service'],
      File['/etc/systemd/system/puppet-apply.timer'],
    ],
  }

  # g10k Configuration
  file { '/etc/g10k/':
    ensure  => directory,
  }

  file { '/etc/g10k/g10k.yaml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('vision_base/g10k.yaml.erb'),
    require => File['/etc/g10k'],
  }

}
