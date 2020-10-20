require 'spec_helper_acceptance'

describe 'vision_base' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class vision_base::docker () {}

        class { 'vision_base': }
      FILE

      # Systemd not functional in Docker
      apply_manifest(pp, catch_failures: false)
    end
  end

  context 'Defaults' do
    describe file('/data') do
      it { is_expected.to be_directory }
    end
    describe file('/etc/profile.d/vision_defaults.sh') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end

  context 'Users provisioned' do
    describe user('rick') do
      it { is_expected.to exist }
      it { is_expected.to have_home_directory '/home/rick' }
      it { is_expected.to have_authorized_key 'ssh-ed25519 aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ==' }
    end
  end

  context 'unattended-upgrades installed' do
    describe package('unattended-upgrades') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end

  context 'SSH configured' do
    describe file('/etc/ssh/sshd_config') do
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
    end
  end

  context 'Puppet installed' do
    describe package('puppet-agent') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/puppetlabs/puppet/hiera.yaml') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match '_key.pem' }
    end
    describe file('/etc/puppetlabs/puppet/puppet.conf') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'production' }
    end
    describe file('/etc/puppetlabs/puppet/site.pp') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'role' }
    end
    describe file('/etc/systemd/system/puppet-apply.timer') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'Timer' }
    end
    describe file('/etc/systemd/system/puppet-apply.service') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'Type=oneshot' }
    end
  end
end
