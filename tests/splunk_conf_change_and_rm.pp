import 'setup.pp'

splunk_conf { 'monitor:///foo/bar/baz.log':
  config_file  => '/tmp/test-splunk-config.conf',
  set          => {
    'index'    => 'index_bar',
    'disabled' => 'false',
  },
  rm => [
    'followTail'
  ],
}
