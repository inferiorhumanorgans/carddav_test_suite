=begin
5.1. DAV:owner

  This  property identifies a particular principal as being the "owner"
  of the resource.  Since the owner of a resource often has special
  access control capabilities (e.g., the owner frequently has permanent
  DAV:write-acl privilege), clients might display the resource owner in
  their user interface.

  Servers MAY implement DAV:owner as protected property and MAY return
  an empty DAV:owner element as property value in case no owner
  information is available.

  <!ELEMENT owner (href?)>
=end

require 'spec_helper'

[:principal, :addressbook].each do |resource_type|

  describe "PROPFIND DAV:owner (#{resource_type} resource)" do
    require_default_auth
    setup_single_property('owner', :ns_prefix => 'D')

    case resource_type
    when :principal then
      do_propfind(:principals => :first, :depth => 0)
      before(:all) do
        @object = @principal
      end
    when :addressbook
      do_propfind(:addressbooks => :mine, :depth => 0)
      before(:all) do
        @object = @addressbook
      end
    end

    it "should return a well-formatted response" do
      check_propget_one(@prop)
    end

    it "should return the correct href" do
      response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

      # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
      @response.xpath(response_href_xpath).text.should be_similar_to_href(@object[:href])
    end

    it "should return a succesful result" do
      status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
      @response.xpath(status_xpath).text.should be_success
    end
  end
end