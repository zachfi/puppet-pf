require 'spec_helper'

describe 'pf' do
  context 'on OpenBSD' do
    let(:facts) { {:kernel => 'OpenBSD'} }
    let(:params) { { :template => 'pf/default.erb' } }
    it { should contain_class('pf') }
    it { should_not contain_service('pf') }

  end

  context 'on FreeBSD' do
    let(:facts) { {:kernel => 'FreeBSD'} }
    let(:params) { { :template => 'pf/default.erb' } }
    it { should contain_class('pf') }
    it { should contain_service('pf') }

  end
end