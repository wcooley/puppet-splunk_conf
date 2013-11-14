import 'setup.pp'

splunk_conf::inputs::monitor { '/foo/bar/baz.log':
  inputs_conf  => '/tmp/test-splunk-inputs.conf',
  set          => {
    'index'    => 'index_bar',
    'disabled' => 'false',
  },
  rm => [
    'followTail'
  ],
}
