require 'spec_helper'

describe 'pf::macro' do
  context 'on OpenBSD' do
    let(:facts) { {
        :kernel => 'OpenBSD',
        :concat_basedir => '/dne'
    } }
    let(:title) { 'sprinkler' }
    let(:params) { {:value => '123.123.123.123' } }

    it { should contain_concat__fragment('sprinkler.pf').with(
      :content=>/^sprinkler = 123.123.123.123$/,
      :target =>'/etc/pf.d/macros.pf'
      )
    }

  end

  context 'on FreeBSD' do
    let(:facts) { {
        :kernel => 'FreeBSD',
        :concat_basedir => '/dne'
    } }
    let(:title) { 'sprinkler' }
    let(:params) { {:value => '123.123.123.123' } }

    it { should contain_concat__fragment('sprinkler.pf').with(
      :content=>/^sprinkler = 123.123.123.123$/,
      :target =>'/etc/pf.d/macros.pf'
      )
    }

  end
end


