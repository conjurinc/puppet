source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV['PUPPET_VERSION'].to_s.empty? ? '~> 4.8.0' : ENV['PUPPET_VERSION']

gem 'metadata-json-lint'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '~> 2.1.0'
gem 'puppet-blacksmith', '~> 3.4.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet', git: 'https://github.com/conjur/rspec-puppet.git', tag: 'v2.5.0-support-sensitive'
gem 'rspec_junit_formatter'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'
end
