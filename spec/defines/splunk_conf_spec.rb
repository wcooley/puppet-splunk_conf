require 'spec_helper'

describe 'splunk_conf' do

  context 'basic test' do
    stanza = 'monitor:///foo/bar/baz.log'
    let(:title) { stanza }
    let(:params) do {
        :config_file => 'test-splunk-config.conf',
        :set => {
          'index' => 'index_foo',
          'sourcetype' => 'sourcetype_bar',
        },
        :rm => [ 'rmattr1', 'rmattr2' ],
      }
    end

    it { should contain_augeas("splunk_conf-#{stanza}").with({
        :changes => [
          "defnode target target[. = '#{stanza}'] #{stanza}",
          "set $target/index index_foo",
          "set $target/sourcetype sourcetype_bar",
          "rm $target/rmattr1",
          "rm $target/rmattr2",
        ],
        :incl => 'test-splunk-config.conf',
      })
    }
  end

  context 'remove stanza' do
    stanza = 'monitor:///foo/bar/baz.log2'
    let(:title) { stanza }
    let(:params) do {
        :config_file => 'test-splunk-config.conf',
        :ensure => 'absent',
      }
    end

    it { should contain_augeas("splunk_conf-#{stanza}").with({
        :changes => "rm target[. = '#{stanza}']",
        :incl => 'test-splunk-config.conf',
      })
    }
  end
end

describe 'splunk_conf' do
  context 'augeas-applied' do
    stanza = 'monitor:///foo/bar/baz.log'
    let(:title) { stanza }
    let(:params) do {
        :config_file => '/tmp/test-splunk-config.conf',
        :set => {
          'index' => 'index_foo',
        }
      }
    end

    it { should contain_augeas("splunk_conf-#{stanza}").with({
        :changes => [
          "defnode target target[. = '#{stanza}'] #{stanza}",
          "set $target/index index_foo",
        ],
        :incl => '/tmp/test-splunk-config.conf',
        :lens => 'Splunk.lns',
      })
    }

    describe_augeas "splunk_conf-#{stanza}",
        :fixture => 'tmp/test-splunk-config.conf',
        :lens => 'Splunk',
        :target => 'tmp/test-splunk-config.conf' do
      it 'should run augparse' do
        pending 'rspec-puppet-augeas working w/local lens'
        #should execute.with_change
        augparse()
#        aug_get("/files/tmp/test-splunk-config.conf/monitor:///foo/bar/baz.log/index").should == 'index_foo'
        #should execute.idempotently
      end
    end
  end
end
