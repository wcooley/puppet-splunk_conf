define splunk_conf::inputs::monitor (
    $ensure = 'present',
    $index = undef,
    $sourcetype= undef,
    $host = undef,
    $disabled = 'false',
    $followTail = 0,
    $inputs_conf = '/opt/splunk/etc/system/local/inputs.conf'
  ) {

  $file_monitor = "monitor://${title}"

  if $ensure == 'present' {
    augeas { "splunk-inputs-add-stanza-${file_monitor}":
      lens    => 'Splunk.lns',
      incl    => $inputs_conf,
      changes => [
        "set target[last()+1] ${file_monitor}",
      ],
      onlyif => "match *[. = '${file_monitor}'] size == 0",
    }

    $index_set = $index ? { undef => '',
      default => "set \$target/index ${index}",
    }

    $sourcetype_set = $sourcetype ? { undef  => '',
      default => "set \$target/sourcetype ${sourcetype}",
    }
    
    $host_set = $host ? { undef  => '',
      default => "set \$target/host ${host}",
    }

    $disabled_set = $disabled ? { undef => '',
      default => "set \$target/disabled ${disabled}",
    }

    $followTail_set = $followTail ? { undef => '',
      default => "set \$target/followTail ${followTail}",
    }

    augeas { "splunk-inputs-update-stanza-${file_monitor}":
      lens    => 'Splunk.lns',
      incl    => $inputs_conf,
      changes => [
        "defvar target target[. = '${file_monitor}']",
        $index_set,
        $sourcetype_set,
        $host_set,
        $disabled_set,
        $followTail_set,
      ]
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
