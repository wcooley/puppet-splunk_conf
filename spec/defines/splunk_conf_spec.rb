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

describe 'splunk_conf' do
  context 'augeas applied to file' do
    stanza = 'monitor:///foo/bar/baz.log'
    target_file = 'tmp/test-splunk-config.conf'

    let(:title) { stanza }
    let(:params) do {
        :config_file => '/' + target_file,
        :set => {
          'index' => 'index_foo',
          'sourcetype' => 'sourcetype_bar',
        },
        :rm => ['rmattr1'],
      }
    end

    describe_augeas "splunk_conf-#{stanza}",
        :lens => 'Splunk',
        :target => target_file do
      it { should execute.with_change }
      it { should execute.idempotently }
      aug_path = "/files/#{target_file}/target[. = '#{stanza}']/"
      it 'sets correct index' do
        aug_get("#{aug_path}/index").should == 'index_foo'
      end
      it 'sets correct sourcetype' do
        aug_get("#{aug_path}/sourcetype").should == 'sourcetype_bar'
      end
      it 'removes correct attribute' do
        aug_match("#{aug_path}/rmattr1").should be_empty
      end
    end
  end

  context 'augeas applied to empty file' do
    pending("not working for some reason") do

    stanza = 'monitor:///foo/bar/baz.log'
    target_file = 'tmp/empty-splunk-config.conf'

    let(:title) { stanza }
    let(:params) do {
        :config_file => '/' + target_file,
        :set => {
          'index' => 'index_foo',
          'sourcetype' => 'sourcetype_bar',
        },
      }
    end

    describe_augeas "splunk_conf-#{stanza}",
        :lens => 'Splunk',
        :target => target_file do
      it { should execute.with_change }
      it { should execute.idempotently }
    end
    end # pending
  end
end
