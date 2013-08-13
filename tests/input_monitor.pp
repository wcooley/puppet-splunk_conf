splunk_conf::inputs::monitor { '/foo/bar/baz.log':
  inputs_conf    => '/tmp/test-splunk-inputs.conf',
  set            =>  {
    'index'      => 'index_foo',
    'sourcetype' => 'sourcetype_foo',
    'host'       => 'host_foo',
    'disabled'   => 'true',
    'followTail' => '1'
  }
}
