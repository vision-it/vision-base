# frozen_string_literal: true

require 'spec_helper'
require 'hiera'

describe 'vision_base::docker' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
      context 'contains service cause cannot beaker test' do
        it { is_expected.to contain_file('/etc/systemd/system/docker-system-prune.service').with_content(/[Service]/) }
        it { is_expected.to contain_file('/etc/systemd/system/docker-system-prune.timer').with_content(/[Timer]/) }
        it { is_expected.to contain_service('docker-system-prune.timer') }
      end
    end
  end
end
