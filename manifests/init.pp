# Class: vision_base
# ===========================
#
# Parameters
# ----------
#
# @param users Users on the system
# @param authorized_keys Authorized SSH keys for a given user
# @param packages Apt packagest to install
#
# Examples
# --------
#
# @example
# contain ::vision_base
#

class vision_base (

  Hash $users,
  Hash $authorized_keys,
  Array $packages = [],

) {

  # Apt Configuration
  contain apt
  contain unattended_upgrades

  # Puppet Configuration
  contain vision_base::puppet

  # NTP Configuration
  # contain vision_base::ntp

  # Docker Configuration
  contain vision_base::docker

  # Default Data Directory
  file { '/data':
    ensure => directory,
  }

  # Default Shell Config
  file { '/etc/profile.d/vision_defaults.sh':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/profile.defaults.sh'),
  }

  # Default Packages
  package { $packages:
    ensure => present,
  }

  # Default values for any user
  $user_defaults = {
    ensure     => present,
    managehome => true,
    groups     => [
      'sudo',
      'adm',
    ]
  }

  create_resources(user, $users, $user_defaults)

  # Default values for any ssh_authorized_key
  $key_defaults = {
    ensure => present,
  }

  create_resources('ssh_authorized_key', $authorized_keys, $key_defaults)

  # SSH Config
  file { '/etc/ssh/sshd_config':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/sshd_config'),
    notify  => Service['ssh'],
  }

  service { 'ssh':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['/etc/ssh/sshd_config'],
  }

  # No need for smartd on VMs
  if $facts['is_virtual'] {
    package { 'smartmontools':
      ensure => absent,
    }
  }

}
