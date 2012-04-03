=begin
5.2. Address Book Collections
  Address book collections appear to clients as a WebDAV collection
  resource, identified by a URL.  An address book collection MUST
  report the DAV:collection and CARDDAV:addressbook XML elements in the
  value of the DAV:resourcetype property.
=end

require 'spec_helper'

describe "PROPFIND resourcetype" do
  require_default_auth
  setup_single_property('resourcetype', :ns_prefix => 'D')
  do_propfind(:addressbooks => :mine, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop, :xsd_prefix => 'addressbook_')
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