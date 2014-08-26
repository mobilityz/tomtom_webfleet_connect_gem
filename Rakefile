require "bundler/gem_tasks"
#require 'ci/reporter/rake/rspec'

require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new(:jenkins_rspec => ["ci:setup:rspec"]) do |t|
  t.pattern = '**/*_spec.rb'
end