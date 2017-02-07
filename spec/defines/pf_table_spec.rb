require 'spec_helper'

describe 'pf::table' do
  let(:title) { 'web_servers' }
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    context "on #{os}" do
      it { is_expected.to contain_concat__fragment('/etc/pf.d/tables/web_servers.pf').with(content: %r{table <web_servers> \{}) }
    end
  end
end
