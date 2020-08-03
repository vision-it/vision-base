# Class: vision_base::docker
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_base::docker
#

class vision_base::docker (

  String $repo_key,
  String $repo_key_id,

) {

  apt::source { 'docker':
    location => 'https://download.docker.com/linux/debian',
    repos    => 'stable',
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

  package {
    [
      'docker-ce',
      'docker-ce-cli',
      'containerd.io'
    ]:
    ensure  => present,
    require => Apt::Source['docker'],
  }

  file { '/etc/docker/daemon.json':
    ensure  => present,
    mode    => '0644',
    content => file('vision_base/daemon.json'),
    require => Package['containerd.io'],
    notify  => Service['docker'],
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['containerd.io'],
  }

}
