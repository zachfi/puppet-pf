require 'spec_helper'

describe 'pf::table' do
  context 'on OpenBSD' do
    let(:facts) { {
        :kernel => 'OpenBSD',
        :concat_basedir => '/dne'
    } }
    let(:title) { 'web_servers' }
    it { should contain_concat__fragment('/etc/pf.d/tables/web_servers.pf').with(:content=>/table <web_servers> {/) }

  end

  context 'on FreeBSD' do
    let(:facts) { {
        :kernel => 'FreeBSD',
        :concat_basedir => '/dne'
    } }
    let(:title) { 'web_servers' }
    it { should contain_concat__fragment('/etc/pf.d/tables/web_servers.pf').with(:content=>/table <web_servers> {/) }

  end
end

