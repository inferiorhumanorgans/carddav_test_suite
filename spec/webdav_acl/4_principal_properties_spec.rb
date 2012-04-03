=begin
4. Principal Properties

  Principals are manifested to clients as a WebDAV resource, identified
  by a URL.  A principal MUST have a non-empty DAV:displayname property
  (defined in Section 13.2 of [RFC2518]), and a DAV:resourcetype
  property (defined in Section 13.9 of [RFC2518]).  Additionally, a
  principal MUST report the DAV:principal XML element in the value of
  the DAV:resourcetype property.  The element type declaration for
  DAV:principal is:

  <!ELEMENT principal EMPTY>
=end

require 'spec_helper'

describe "PROPFIND displayname (principal resource)" do
  require_default_auth
  setup_single_property('displayname', :ns_prefix => 'D')
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop, :xsd_prefix => 'principal_')
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

describe "PROPFIND resourcetype (principal resource)" do
  require_default_auth
  setup_single_property('resourcetype', :ns_prefix => 'D')
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop, :xsd_prefix => 'principal_')
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