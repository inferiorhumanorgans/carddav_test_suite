=begin
6.1. Address Book Support

  A server supporting the features described in this document MUST
  include "addressbook" as a field in the DAV response header from an
  OPTIONS request on any resource that supports any address book
  properties, reports, or methods.  A value of "addressbook" in the DAV
  response header MUST indicate that the server supports all MUST level
  requirements and REQUIRED features specified in this document.
=end

require 'spec_helper'

describe "OPTIONS (addressbook)" do
  require_default_auth

  it "should indicate addressbook support on the address book resource" do
    # Do this in case someone's specified multiple DAV headers
    dav_capabilities = @dav.options(CONFIG[:addressbooks][:mine][:href]).get_fields('DAV')
      .join(',')
      .split(',')
      .collect {|h| h.downcase.strip}

    dav_capabilities.should include 'addressbook'
  end

  it "should indicate addressbook support on the principal resource" do
    # Do this in case someone's specified multiple DAV headers
    dav_capabilities = @dav.options(CONFIG[:principals][:first][:href]).get_fields('DAV')
      .join(',')
      .split(',')
      .collect {|h| h.downcase.strip}

    dav_capabilities.should include 'addressbook'
  end
end