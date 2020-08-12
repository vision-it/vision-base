# Class: vision_base
# ===========================
#
# Parameters
# ----------
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
    ensure  => directory,
  }

  # Default values for any user
  $user_defaults = {
    ensure         => present,
    managehome     => true,
    groups         => [
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
    service { 'smartd':
      ensure => stopped,
      enable => false,
    }
  }

}
