require 'spec_helper'

describe 'pf' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { { template: 'pf/default.epp' } }

      case facts[:kernel]
      when 'OpenBSD'
        it { is_expected.to contain_class('pf') }
        it { is_expected.not_to contain_service('pf') }
        it { is_expected.to contain_file('/etc/pf.conf') }
        it { is_expected.to contain_file('/etc/pf.d').with(ensure: 'directory') }
        it { is_expected.to contain_concat('/etc/pf.d/tables.pf') }
        it { is_expected.to contain_file('/tmp/pf.conf') }
        it { is_expected.to contain_exec('pfctl_update').with(command: '/sbin/pfctl -nf /tmp/pf.conf && cp /tmp/pf.conf /etc/pf.conf && /sbin/pfctl -f /etc/pf.conf') }
      when 'FreeBSD'
        it { is_expected.to contain_class('pf') }
        it { is_expected.to contain_service('pf') }
        it { is_expected.to contain_file('/etc/pf.conf') }
        it { is_expected.to contain_file('/etc/pf.d').with(ensure: 'directory') }
        it { is_expected.to contain_concat('/etc/pf.d/tables.pf') }
        it { is_expected.to contain_file('/tmp/pf.conf') }
        it { is_expected.to contain_exec('pfctl_update').with(command: '/sbin/pfctl -nf /tmp/pf.conf && cp /tmp/pf.conf /etc/pf.conf && /sbin/pfctl -f /etc/pf.conf') }
      end
    end
  end
end
