define splunk_conf (
    $config_file,
    $set = {},
    $rm = [],
    $ensure = 'present'
  ) {

  if $ensure == 'present' {

    $changes = flatten([
      "defnode target target[. = '${title}'] ${title}",
      prefix(join_keys_to_values($set, ' '), 'set $target/'),
      prefix($rm, 'rm $target/'),
    ])

    #$changes_print = join($changes, "\n")
    #notice("\$changes:\n${changes_print}")

    augeas { "splunk_conf-${title}":
      lens    => 'Splunk.lns',
      incl    => $config_file,
      changes => $changes,
    }
  }

  elsif $ensure == 'absent' {
    augeas { "splunk_conf-${title}":
      lens    => 'Splunk.lns',
      incl    => $config_file,
      changes => [
        "rm target[. = '${title}']",
      ],
      onlyif => "match *[. = '${title}'] size > 0",
    }
  }

  else {
    fail("status=unrecognized_value name=ensure value=\"${ensure}\"")
  }
}
