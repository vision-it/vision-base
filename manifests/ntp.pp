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
# contain ::vision_base::ntp
#

class vision_base::ntp (

  Array[String] $servers,
  Array[String] $restrictions,
  String $driftfile = '/var/lib/ntp/ntp.drift',

) {

  class { '::ntp':
    driftfile     => $driftfile,
    iburst_enable => true,
    restrict      => $restrictions,
    servers       => $servers,
  }

}
