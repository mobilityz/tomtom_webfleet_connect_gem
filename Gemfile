source 'https://rubygems.org'
ruby '1.9.3'

gem 'activerecord', '3.2.11'
gem 'activemodel', '3.2.11' #, "~> 3.2.14"
gem 'httparty', '0.10.0'
gem "rack", "~> 1.5.2"

group :development, :test do
  gem 'rake'
  gem 'rspec', '~> 3.0.0'
  gem 'rspec-its', '~> 1.0.1'
  gem 'rspec-legacy_formatters'
end

group :test do
  gem 'ci_reporter', '~> 1.9.2'
  gem 'sqlite3'
  gem 'simplecov'
  gem 'simplecov-rcov'
end

# Specify your gem's dependencies in tomtom-webfleet-connect.gemspec
gemspec