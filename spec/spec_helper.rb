$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'net/dav'
require 'pathname'
require 'nokogiri'
require 'yaml'
require 'pathname'

CONFIG = YAML.load_file('config.yml')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Dir.pwd+"/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include PropgetMacros
  config.extend DAVClassMacros
  config.include DAVInstanceMacros

  config.include Matchers::XSD
  config.include Matchers::DAV
end