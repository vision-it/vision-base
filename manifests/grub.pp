# Class: vision_base::grub
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_base::grub
#

class vision_base::grub (

) {

  file { '/etc/default/grub.d/hugepages.cfg':
    ensure  => present,
    mode    => '0644',
    content => 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX transparent_hugepage=madvise"',
  }

  exec { 'update-grub':
    command     => '/usr/sbin/update-grub',
    subscribe   => File['/etc/default/grub.d/hugepages.cfg'],
    refreshonly => true,
  }
}
