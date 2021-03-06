# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'vision_base' do
  context 'with defaults' do
    it 'run idempotently' do
      setup = <<-FILE
        file { '/etc/default/grub.d/':
         ensure  => directory,
        }
        file { '/usr/sbin/update-grub':
         ensure  => present,
         mode    => '0744',
        }
      FILE
      apply_manifest(setup, catch_failures: false)

      pp = <<-FILE
        class vision_base::docker () {}

        class { 'vision_base': }
      FILE

      # Systemd not functional in Docker
      apply_manifest(pp, catch_failures: false)
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
    describe package('zile') do
      it { is_expected.to be_installed }
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
    describe file('/etc/g10k/g10k.yaml') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'production' }
      its(:content) { is_expected.to match 'foobar@git' }
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

  context 'manage sudoers' do
    describe package('sudo') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/sudoers.d/80_sudoers') do
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'NOPASSWD' }
      it { is_expected.to be_mode 440 }
    end
    describe command('visudo -c') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'manage swap' do
    describe file('/swap') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_mode 600 }
    end
  end

  context 'manage grub' do
    describe file('/etc/default/grub.d/hugepages.cfg') do
      its(:content) { is_expected.to match 'madvise' }
      it { is_expected.to be_mode 644 }
    end
  end
end
