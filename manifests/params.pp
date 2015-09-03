class pf::params {
  case $::kernel {
    'OpenBSD': {
      $manage_service = false
      $service_enable = false
    }
    'FreeBSD': {
      $manage_service = true
      $service_enable = true
    }
  }
}