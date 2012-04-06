$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'yaml'
require 'pathname'

require 'rubygems'

require 'rspec'
require 'net/dav'
require 'nokogiri'

CONFIG = YAML.load_file('config.yml')
XML_PATH = Pathname.new(Dir.pwd).join('xml')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Dir.pwd+"/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.extend PropfindClassMacros
  config.include PropfindInstanceMacros

  config.extend DAVClassMacros
  config.include DAVInstanceMacros

  config.include Matchers::XSD
  config.include Matchers::DAV
end