require 'spec_helper'

describe 'splunk_conf' do

  context 'basic test' do
    stanza = 'monitor:///foo/bar/baz.log'
    let(:title) { stanza }
    let(:params) do {
        :config_file => 'test-splunk-config.conf',
        :set => {
          'index' => 'index_foo',
# FIXME: Figure out how to introduce some determinism or change spec below to
# somehow allow for the two "set" lines to be in arbitrary order.
# Right now, it is not possible to test and get consistent results.
#          'sourcetype' => 'sourcetype_bar',
        },
        :rm => [ 'rmattr1', 'rmattr2' ],
      }
    end

    it { should contain_augeas("splunk_conf-#{stanza}").with({
        :changes => [
          "defnode target target[. = '#{stanza}'] #{stanza}",
          "set $target/index index_foo",
#          "set $target/sourcetype sourcetype_bar",
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
