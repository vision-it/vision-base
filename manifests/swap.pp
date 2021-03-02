# Class: vision_base::swap
# ===========================
#
# Parameters
# ----------
#
# @param swapfile Path to swapfile
# @param swapsize Size of swap, see man fallocate (example: 512MB, 1GB)
#
# Examples
# --------
#
# @example
# contain ::vision_base::ntp
#

class vision_base::swap (

  String $swapfile = '/swap',
  String $swapsize = '1GB',

) {

  # Create Swap file if not exists
  exec { "Create swap file ${swapfile}":
    creates => $swapfile,
    timeout => 300,
    command => "/usr/bin/fallocate -l ${swapsize} ${swapfile} && /usr/sbin/mkswap ${swapfile}"
  }

  file { $swapfile:
    owner   => root,
    group   => root,
    mode    => '0600',
    require => Exec["Create swap file ${swapfile}"],
  }

  # Enable Swap
  exec { "Enable swap file ${swapfile}":
    command => "/usr/sbin/swapon ${swapfile}",
    unless  => "/usr/sbin/swapon -s | grep -q ${swapfile}",
    require => File[$swapfile],
  }

  # Add fstab entry
  mount { $swapfile :
    ensure  => present,
    fstype  => 'swap',
    atboot  => 'yes',
    device  => $swapfile,
    dump    => 0,
    pass    => 0,
    options => 'defaults',
    require => Exec["Enable swap file ${swapfile}"],
  }

}
