=begin
6.2.3. CARDDAV:max-resource-size Property
  Name:  max-resource-size

  Namespace:  urn:ietf:params:xml:ns:carddav

  Purpose:  Provides a numeric value indicating the maximum size in
    octets of a resource that the server is willing to accept when an
    address object resource is stored in an address book collection.

  Value:  Any text representing a numeric value.

  Protected:  MUST be protected as it indicates limits provided by the
    server.

  COPY/MOVE behavior:  This property value MUST be preserved in COPY
    and MOVE operations.

  allprop behavior:  SHOULD NOT be returned by a PROPFIND DAV:allprop
    request.

  Description:  The CARDDAV:max-resource-size is used to specify a
    numeric value that represents the maximum size in octets that the
    server is willing to accept when an address object resource is
    stored in an address book collection.  Any attempt to store an
    address book object resource exceeding this size MUST result in an
    error, with the CARDDAV:max-resource-size precondition
    (Section 6.3.2.1) being violated.  In the absence of this
    property, the client can assume that the server will allow storing
    a resource of any reasonable size.

  Definition:
    <!ELEMENT max-resource-size (#PCDATA)>
    <!-- PCDATA value: a numeric value (positive decimal integer) -->

  Example:
    <C:max-resource-size xmlns:C="urn:ietf:params:xml:ns:carddav">102400</C:max-resource-size>
=end
require 'spec_helper'

describe "PROPFIND max-resource-size" do
  require_default_auth

  setup_single_property('max-resource-size')

  it "should return a well-formatted response" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)
    check_propget_one(@prop)
  end

  it "should return the correct href" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)

    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@addressbook[:href])
    
    # addressbook_href_xpath = "#{property_xpath}/#{card_ns}addressbook-home-set/#{@dav_ns}href"
    # response.xpath(addressbook_href_xpath).text.should == 'a valid path or URL'
  end
  
  it "should return a succesful result" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end