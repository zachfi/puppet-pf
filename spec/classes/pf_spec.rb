require 'spec_helper'

describe 'pf' do
  context 'on OpenBSD' do
    let(:facts) { {
        :kernel => 'OpenBSD',
        :concat_basedir => '/dne'
    } }
    let(:params) { { :template => 'pf/default.erb' } }
    it { should contain_class('pf') }
    it { should_not contain_service('pf') }
    it { should contain_file('/etc/pf.conf') }
    it { should contain_file('/etc/pf.d').with(:ensure=>'directory') }
    it { should contain_concat('/etc/pf.d/tables.pf') }
    it { should contain_file('/tmp/pf.conf') }
    it { should contain_exec('pfctl_update').with(:command=>'/sbin/pfctl -nf /tmp/pf.conf && cp /tmp/pf.conf /etc/pf.conf && /sbin/pfctl -f /etc/pf.conf') }

  end
  let(:facts) {
    {
        :operatingsystem => operatingsystem,
    }
  }

  context 'on FreeBSD' do
    let(:facts) { {
        :kernel => 'FreeBSD',
        :concat_basedir => '/dne'
    } }
    let(:params) { { :template => 'pf/default.erb' } }
    it { should contain_class('pf') }
    it { should contain_service('pf') }
    it { should contain_file('/etc/pf.conf') }
    it { should contain_file('/etc/pf.d').with(:ensure=>'directory') }
    it { should contain_concat('/etc/pf.d/tables.pf') }
    it { should contain_file('/tmp/pf.conf') }
    it { should contain_exec('pfctl_update').with(:command=>'/sbin/pfctl -nf /tmp/pf.conf && cp /tmp/pf.conf /etc/pf.conf && /sbin/pfctl -f /etc/pf.conf') }

  end
end
