require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'net/dav'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*spec.rb'
end

task :default => :spec