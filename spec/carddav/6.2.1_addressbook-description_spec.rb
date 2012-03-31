=begin
6.2.1. CARDDAV:addressbook-description Property
  Name:  addressbook-description

  Namespace:  urn:ietf:params:xml:ns:carddav

  Purpose:  Provides a human-readable description of the address book
    collection.

  Value:  Any text.

  Protected:  SHOULD NOT be protected so that users can specify a
    description.

  COPY/MOVE behavior:  This property value SHOULD be preserved in COPY
    and MOVE operations.

  allprop behavior:  SHOULD NOT be returned by a PROPFIND DAV:allprop
    request.

  Description:  This property contains a description of the address
    book collection that is suitable for presentation to a user.  The
    xml:lang attribute can be used to add a language tag for the value
    of this property.

  Definition:
    <!ELEMENT addressbook-description (#PCDATA)>
    <!-- PCDATA value: string -->

  Example:
  <C:addressbook-description xml:lang="fr-CA" xmlns:C="urn:ietf:params:xml:ns:carddav">
    Adresses de Oliver Daboo
  </C:addressbook-description>
=end

require 'spec_helper'

describe "PROPFIND addressbook-description" do
  require_default_auth
  setup_single_property('addressbook-description')
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