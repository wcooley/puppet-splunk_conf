define splunk_conf (
    $config_file,
    $set = {},
    $rm = [],
    $ensure = 'present'
  ) {

  case $ensure {
    'present': {
      $changes = flatten([
        "defnode target target[. = '${title}'] ${title}",
        prefix(join_keys_to_values($set, ' '), 'set $target/'),
        prefix($rm, 'rm $target/'),
      ])
    }
    'absent': {
      $changes = "rm target[. = '${title}']"
    }
    default: {
      fail("status=unrecognized_value name=ensure value=\"${ensure}\"")
    }
  }

  #notice("\nchanging config: ${config_file}")
  #$changes_print = join(flatten([$changes]), "\n")
  #notice("\$changes:\n${changes_print}")

  augeas { "splunk_conf-${title}":
    lens    => 'Splunk.lns',
    incl    => $config_file,
    changes => $changes,
  }

}
