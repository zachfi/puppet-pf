require 'spec_helper'

describe 'pf::macro' do
  on_supported_os.each do |os, facts|
    let(:title) { 'sprinkler' }
    let(:params) { { value: '123.123.123.123' } }

    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { { value: '123.123.123.123' } }

      it do
        is_expected.to contain_concat__fragment('sprinkler.pf').with(
          content: %r{^sprinkler = 123.123.123.123$},
          target: '/etc/pf.d/macros.pf'
        )
      end
    end
  end
end
