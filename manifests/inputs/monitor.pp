define splunk_conf::inputs::monitor (
    $set = undef,
    $rm = undef,
    $ensure = 'present',
    $inputs_conf = '/opt/splunk/etc/system/local/inputs.conf'
  ) {

  $file_monitor = "monitor://${title}"

  splunk_conf { $file_monitor:
    ensure      => $ensure,
    config_file => $inputs_conf,
    set         => $set,
    rm          => $rm,
  }

}
