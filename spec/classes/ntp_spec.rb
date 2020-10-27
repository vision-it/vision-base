# frozen_string_literal: true

require 'spec_helper'
require 'hiera'

describe 'vision_base::ntp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
