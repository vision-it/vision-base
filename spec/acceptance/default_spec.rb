require 'spec_helper_acceptance'

describe 'vision_base' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_base': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'Users provisioned' do
    describe user('rick') do
      it { should exist }
      it { should have_home_directory '/home/rick' }
      it { should have_authorized_key 'ssh-ed25519 aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ==' }
    end
  end

  context 'unattended-upgrades installed' do
    describe package('unattended-upgrades') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
      it { is_expected.to exist }
      it { is_expected.tos be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end

  context 'Puppet installed' do
    describe package('puppet') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/puppet/hiera.yaml') do
      it { is_expected.to exist }
      it { is_expected.tos be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'pkcs7' }
    end
    describe file('/etc/puppet/puppet.conf') do
      it { is_expected.to exist }
      it { is_expected.tos be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'development' }
    end
    describe file('/etc/puppet/code/site.pp') do
      it { is_expected.to exist }
      it { is_expected.tos be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'role' }
    end
  end
end
