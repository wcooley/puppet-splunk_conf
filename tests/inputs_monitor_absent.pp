import 'setup.pp'

splunk_conf::inputs::monitor { '/foo/bar/baz.log':
  ensure      => 'absent',
  inputs_conf => '/tmp/test-splunk-inputs.conf',
}
