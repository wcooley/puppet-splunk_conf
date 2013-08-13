define splunk_conf::inputs::monitor (
    $set = undef,
    $rm = undef,
    $ensure = 'present',
    $inputs_conf = '/opt/splunk/etc/system/local/inputs.conf'
  ) {

  $file_monitor = "monitor://${title}"

  if $ensure == 'present' {

    $changes = flatten([
      "defnode target target[. = '${file_monitor}'] ${file_monitor}",
      prefix(join_keys_to_values($set, ' '), 'set $target/'),
      prefix($rm, 'rm $target/'),
    ])

    #$changes_print = join($changes, "\n")
    #notice("\$changes:\n${changes_print}")

    augeas { "splunk-inputs-update-stanza-${file_monitor}":
      lens    => 'Splunk.lns',
      incl    => $inputs_conf,
      changes => $changes,
    }
  }

  elsif $ensure == 'absent' {
    augeas { "splunk-inputs-rm-stanza-${file_monitor}":
      lens    => 'Splunk.lns',
      incl    => $inputs_conf,
      changes => [
        "rm target[. = '${file_monitor}']",
      ],
      onlyif => "match *[. = '${file_monitor}'] size > 0",
    }
  }

  else {
    fail("status=unrecognized_value name=ensure value=\"${ensure}\"")
  }
}
