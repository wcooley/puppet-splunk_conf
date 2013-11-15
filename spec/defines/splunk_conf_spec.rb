require 'spec_helper'

describe 'splunk_conf' do
  context 'generic system' do
    let(:title) { 'monitor:///foo/bar/baz.log' }
    let(:params) { {
        :config_file => '/tmp/test-splunk-config.conf',
    } }
    it { should contain_augeas('splunk_conf-monitor:///foo/bar/baz.log') }
  end
end
