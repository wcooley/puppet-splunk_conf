require 'spec_helper'

describe 'splunk_conf' do
  stanza = 'monitor:///foo/bar/baz.log'

  context 'puppet catalog' do
    context 'sets and rms' do
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

      it 'has an augeas type with sets and rms' do
        should contain_augeas("splunk_conf-#{stanza}").with({
          :changes => [
            "defnode target target[. = '#{stanza}'] #{stanza}",
            "set $target/index index_foo",
            "set $target/sourcetype sourcetype_bar",
            "rm $target/rmattr1",
            "rm $target/rmattr2",
          ],
          :incl => 'test-splunk-config.conf',
        })
      end
    end

    context 'ensure => absent' do
      let(:title) { stanza }
      let(:params) do {
          :config_file => 'test-splunk-config.conf',
          :ensure => 'absent',
        }
      end

      it 'has an augeas type that removes target' do
        should contain_augeas("splunk_conf-#{stanza}").with({
          :changes => "rm target[. = '#{stanza}']",
          :incl => 'test-splunk-config.conf',
        })
      end
    end
  end
end
