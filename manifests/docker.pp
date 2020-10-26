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

  class { '::docker':
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

}
