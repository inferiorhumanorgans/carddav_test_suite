=begin
7.1.1. CARDDAV:addressbook-home-set Property
  Name:  addressbook-home-set

  Namespace:  urn:ietf:params:xml:ns:carddav

  Purpose:  Identifies the URL of any WebDAV collections that contain
    address book collections owned by the associated principal
    resource.

  Protected:  MAY be protected if the server has fixed locations in
    which address books are created.

  COPY/MOVE behavior:  This property value MUST be preserved in COPY
    and MOVE operations.

  allprop behavior:  SHOULD NOT be returned by a PROPFIND DAV:allprop
    request.

  Description:  The CARDDAV:addressbook-home-set property is meant to
    allow users to easily find the address book collections owned by
    the principal.  Typically, users will group all the address book
    collections that they own under a common collection.  This
    property specifies the URL of collections that are either address
    book collections or ordinary collections that have child or
    descendant address book collections owned by the principal.

  Definition:
    <!ELEMENT addressbook-home-set (DAV:href*)>

  Example:
  <C:addressbook-home-set xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
    <D:href>/bernard/addresses/</D:href>
  </C:addressbook-home-set>

  As a PROPFIND:
  <?xml version="1.0"?>
   <D:multistatus xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
     <D:response>
       <D:href>/carddav</D:href>
       <D:propstat>
         <D:prop>
           <C:addressbook-home-set xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
             <D:href>/bernard/addresses/</D:href>
           </C:addressbook-home-set>
         </D:prop>
         <D:status>HTTP/1.1 200 OK</D:status>
       </D:propstat>
     </D:response>
   </D:multistatus>
=end

require 'spec_helper'

describe "PROPFIND addressbook-home-set" do
  require_default_auth
  setup_single_property 'addressbook-home-set'
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop)
  end
  
  it "should return the correct href" do
    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@principal[:href])
    
    # addressbook_href_xpath = "#{property_xpath}/#{card_ns}addressbook-home-set/#{@dav_ns}href"
    # response.xpath(addressbook_href_xpath).text.should == 'a valid path or URL'
  end
  
  it "should return a succesful result" do
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end