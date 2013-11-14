import 'setup.pp'

splunk_conf { 'monitor:///foo/bar/baz.log':
  config_file    => '/tmp/test-splunk-config.conf',
  set            =>  {
    'index'      => 'index_foo',
    'sourcetype' => 'sourcetype_foo',
    'host'       => 'host_foo',
    'disabled'   => 'true',
    'followTail' => '1'
  }
}

splunk_conf { 'duplicate-stanza-different-file':
  config_file    => '/tmp/test-splunk-config2.conf',
  stanza         => 'monitor:///foo/bar/baz.log',
  set            =>  {
    'index'      => 'index_foo',
    'sourcetype' => 'sourcetype_foo',
    'host'       => 'host_foo',
    'disabled'   => 'true',
    'followTail' => '1'
  }
}
