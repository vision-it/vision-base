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

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/sshd_config'),
    notify => Service['sshd'],
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['/etc/ssh/sshd_config'],
  }

}
