splunk_conf::inputs::monitor { '/foo/bar/baz.log':
  ensure      => 'absent',
  inputs_conf => '/tmp/test-splunk-inputs.conf',
  index       => 'index_foo',
  sourcetype  => 'sourcetype_foo',
  host        => 'host_foo',
  disabled    => 'true',
  followTail  => '1',
}
