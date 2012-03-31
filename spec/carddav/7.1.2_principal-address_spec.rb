=begin
7.1.2. CARDDAV:principal-address Property
  Name:  principal-address

  Namespace:  urn:ietf:params:xml:ns:carddav

  Purpose:  Identifies the URL of an address object resource that
    corresponds to the user represented by the principal.

  Protected:  MAY be protected if the server provides a fixed location
    for principal addresses.

  COPY/MOVE behavior:  This property value MUST be preserved in COPY
    and MOVE operations.

  allprop behavior:  SHOULD NOT be returned by a PROPFIND DAV:allprop
    request.

  Description:  The CARDDAV:principal-address property is meant to
    allow users to easily find contact information for users
    represented by principals on the system.  This property specifies
    the URL of the resource containing the corresponding contact
    information.  The resource could be an address object resource in
    an address book collection, or it could be a resource in a
    "regular" collection.

  Definition:
    <!ELEMENT principal-address (DAV:href)>

  Example:
  <C:principal-address xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
    <D:href>/system/cyrus.vcf</D:href>
  </C:principal-address>
  
  As a PROPFIND:
  <?xml version="1.0"?>
    <D:multistatus xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
      <D:response>
        <D:href>/carddav</D:href>
        <D:propstat>
          <D:prop>
            <C:principal-address xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
              <D:href>/system/cyrus.vcf</D:href>
            </C:principal-address>
          </D:prop>
          <D:status>HTTP/1.1 200 OK</D:status>
        </D:propstat>
      </D:response>
    </D:multistatus>
=end

require 'spec_helper'

describe "PROPFIND principal-address" do
  require_default_auth
  setup_single_property('principal-address')
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one('principal_address')
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