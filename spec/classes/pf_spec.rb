require 'spec_helper'

describe 'pf' do
  context 'on OpenBSD' do
    let(:facts) { {:kernel => 'OpenBSD'} }
    it { should contain_class('pf') }

  end

  context 'on FreeBSD' do
    let(:facts) { {:kernel => 'FreeBSD'} }
    it { should contain_class('pf') }

  end
end