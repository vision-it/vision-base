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

  Hash $registries = {},

) {

  class { '::docker':
  }

  class { '::docker::registry_auth':
    registries => $registries,
  }

  docker::plugin { 'grafana/loki-docker-driver:latest':
    enabled      => true,
    plugin_alias => 'loki',
  }
}
