# Class: vision_base::ntp
# ===========================
#
# Parameters
# ----------
#
# @param servers List of NTP servers
# @param restrictions Restrictions on our network
# @param driftfile Path to dift file
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
