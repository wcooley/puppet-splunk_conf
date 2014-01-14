require 'spec_helper'

describe 'splunk_conf::inputs::monitor' do
  default_inputs_conf = '/opt/splunk/etc/system/local/inputs.conf'
  file_input = '/foo/bar/baz.log'
  stanza = "monitor://#{file_input}"

  context 'puppet compiles catalog' do
    let(:title) { file_input }

    context 'augeas type which sets sourcetype' do
      let(:params) do
        {
          :inputs_conf => default_inputs_conf,
          :set => {
            'sourcetype' => 'sourcetype_bar'
          }
        }
      end

      it 'has an augeas type with set' do
        should contain_augeas("splunk_conf-#{stanza}").with(
          {
            :changes => [
              "defnode target target[. = '#{stanza}'] #{stanza}",
              "set $target/sourcetype sourcetype_bar"
            ],
            :incl => default_inputs_conf,
        })
      end
    end
  end

  context 'applies augeas and adds new stanza' do
    let(:title) { file_input }
    let(:params) do
      {
        :set => {
          'sourcetype' => 'sourcetype_bar'
        }
      }
    end

    describe_augeas "splunk_conf-#{stanza}",
        :lens => 'Splunk',
        :target => default_inputs_conf[1..-1] do
      it { should execute.with_change }
      it { should execute.idempotently }
    end
  end

  context 'applies augeas and removes existing stanza' do
    #stanza = "monitor:///var/log/system.log"
    #let(:title) { stanza }
    #let(:params) { { :ensure => 'absent' } }
    #describe_augeas "splunk_conf-#{stanza}",
    #    :lens => 'Splunk',
    #    :target => default_inputs_conf[1..-1] do

      pending "WIP"
      #it { should execute.with_change }
      #it { should execute.idempotently }
    #end
  end
end
