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

  # Grub Configuration
  contain vision_base::grub

  # Swap Configuration
  contain vision_base::swap

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
      'adm',
    ]
  }

  create_resources(user, $users, $user_defaults)

  # Default values for any ssh_authorized_key
  $key_defaults = {
    ensure => present,
  }

  create_resources('ssh_authorized_key', $authorized_keys, $key_defaults)

  # sudoers config
  package { 'sudo':
    ensure  => present,
  }

  file { '/etc/sudoers.d/80_sudoers':
    ensure  => present,
    mode    => '0440',
    content => file('vision_base/sudoers.d/80_sudoers'),
  }

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
