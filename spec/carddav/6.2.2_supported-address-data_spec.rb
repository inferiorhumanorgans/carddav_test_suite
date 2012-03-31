=begin
6.2.2. CARDDAV:supported-address-data Property
  Name:  supported-address-data

  Namespace:  urn:ietf:params:xml:ns:carddav

  Purpose:  Specifies what media types are allowed for address object
    resources in an address book collection.

  Protected:  MUST be protected as it indicates the level of support
    provided by the server.

  COPY/MOVE behavior:  This property value MUST be preserved in COPY
    and MOVE operations.

  allprop behavior:  SHOULD NOT be returned by a PROPFIND DAV:allprop
    request.

  Description:  The CARDDAV:supported-address-data property is used to
    specify the media type supported for the address object resources
    contained in a given address book collection (e.g., vCard version
    3.0).  Any attempt by the client to store address object resources
    with a media type not listed in this property MUST result in an
    error, with the CARDDAV:supported-address-data precondition
    (Section 6.3.2.1) being violated.  In the absence of this
    property, the server MUST only accept data with the media type
    "text/vcard" and vCard version 3.0, and clients can assume that is
    all the server will accept.

  Definition:
    <!ELEMENT supported-address-data (address-data-type+)>

    <!ELEMENT address-data-type EMPTY>
    <!ATTLIST address-data-type content-type CDATA "text/vcard" version CDATA "3.0">
    <!-- content-type value: a MIME media type -->
    <!-- version value: a version string -->

   Example:
    <C:supported-address-data xmlns:C="urn:ietf:params:xml:ns:carddav">
      <C:address-data-type content-type="text/vcard" version="3.0"/>
    </C:supported-address-data>
=end
require 'spec_helper'

describe "PROPFIND supported-address-data" do
  require_default_auth
  setup_single_property('supported-address-data')
  do_propfind(:addressbooks => :mine, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop)
  end

  it "should return the correct href" do
    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@addressbook[:href])
    
    # addressbook_href_xpath = "#{property_xpath}/#{card_ns}addressbook-home-set/#{@dav_ns}href"
    # response.xpath(addressbook_href_xpath).text.should == 'a valid path or URL'
  end
  
  it "should return a succesful result" do
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end