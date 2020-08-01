source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['6.7.2']
gem 'puppet', puppetversion

gem 'puppetlabs_spec_helper', '2.13.1'
gem 'rake', '12.3.3'
gem 'rspec-puppet', '2.7.3'

group :rubocop do
  gem 'rubocop', '0.65.0'
  gem 'rubocop-rspec', '1.32.0'
end

group :testing do
  gem 'metadata-json-lint', '1.2.2'
  gem 'rspec-puppet-facts', '1.8.0'
end

group :acceptance do
  gem 'serverspec',                         :require => false
  gem 'beaker-docker',                      :require => false
  gem 'beaker-puppet',                      :require => false
  gem 'beaker-puppet_install_helper',       :require => false
  gem 'beaker-rspec',                       :require => false
  gem 'rbnacl', '>= 4',                     :require => false
  gem 'rbnacl-libsodium',                   :require => false
  gem 'bcrypt_pbkdf',                       :require => false
  gem 'ed25519',                            :require => false
end

group :development do
  gem 'travis',      :require => false
  gem 'travis-lint', :require => false
end
