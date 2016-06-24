require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'active_model'
require 'simplecov'
require 'simplecov-rcov'
require 'httparty'

require 'tomtom_webfleet_connect' # and any other gems you need

ENV['RAILS_ENV'] = 'test'

# SimpleCov conf :
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

TomtomWebfleetConnect.logger = Logger.new(STDOUT)
TomtomWebfleetConnect.logger.level = Logger::DEBUG

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => File.dirname(__FILE__) + '/tomtom_webfleet_connect.sqlite3')

load File.dirname(__FILE__) + '/support/schema.rb'

RSpec.configure do |config|

  RAILS_ROOT = Pathname.new(File.expand_path('../..', __FILE__))
  env_file = File.join(RAILS_ROOT, 'config', 'local_env.yml')
  YAML.load(File.open(env_file)).each do |key, value|
    ENV[key.to_s] = value
  end if File.exists?(env_file)

end