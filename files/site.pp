# This file is managed by Puppet
node default {
  $role = lookup('role', String, 'first', 'default')
  contain "vision_roles::${role}"
}
