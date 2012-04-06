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

describe "PROPFIND DAV:owner (principal resource)" do
  require_default_auth
  setup_single_property('owner', :ns_prefix => 'D')
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop)
  end

  it "should return the correct href" do
    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@principal[:href])
  end
  
  it "should return a succesful result" do
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end

describe "PROPFIND DAV:owner (addressbook resource)" do
  require_default_auth
  setup_single_property('owner', :ns_prefix => 'D')
  do_propfind(:addressbooks => :mine, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop)
  end

  it "should return the correct href" do
    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@addressbook[:href])
  end
  
  it "should return a succesful result" do
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end