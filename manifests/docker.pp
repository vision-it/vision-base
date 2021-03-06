# Class: vision_base::docker
# ===========================
#
# Parameters
# ----------
#
# @param registries List of Docker registries to include
#
# Examples
# --------
#
# @example
# contain ::vision_base::docker
#

class vision_base::docker (

  Hash $registries = {},

) {

  # Configure Daemon with better defaults
  class { '::docker':
    extra_parameters => '--no-new-privileges=true --userland-proxy=false',
  }

  # For internal Docker registry
  class { '::docker::registry_auth':
    registries => $registries,
  }

  # For sending logs directrly to Loki
  docker::plugin { 'grafana/loki-docker-driver:latest':
    enabled      => true,
    plugin_alias => 'loki',
  }

  # The docker-prune.service cleans up unused Docker images
  file { '/etc/systemd/system/docker-system-prune.service':
    ensure  => present,
    content => file('vision_base/docker-system-prune.service'),
    notify  => Service['docker-system-prune.timer'],
  }

  file { '/etc/systemd/system/docker-system-prune.timer':
    ensure  => present,
    content => file('vision_base/docker-system-prune.timer'),
    notify  => Service['docker-system-prune.timer'],
  }

  service { 'docker-system-prune.timer':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      File['/etc/systemd/system/docker-system-prune.timer'],
      File['/etc/systemd/system/docker-system-prune.service'],
    ],
  }
}
