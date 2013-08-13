splunk_conf { 'monitor:///foo/bar/baz.log':
  config_file    => '/tmp/test-splunk-inputs.conf',
  set            =>  {
    'index'      => 'index_foo',
    'sourcetype' => 'sourcetype_foo',
    'host'       => 'host_foo',
    'disabled'   => 'true',
    'followTail' => '1'
  }
}
