require 'spec_helper'

# <?xml version="1.0"?>
#  <D:multistatus xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
#    <D:response>
#      <D:href>/carddav</D:href>
#      <D:propstat>
#        <D:prop>
#          <C:addressbook-home-set xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
#            <D:href>/bernard/addresses/</D:href>
#          </C:addressbook-home-set>
#        </D:prop>
#        <D:status>HTTP/1.1 200 OK</D:status>
#      </D:propstat>
#    </D:response>
#  </D:multistatus>
describe "PROPFIND addressbook-home-set" do
  require_default_auth
  setup_single_property 'addressbook-home-set'

  it "should return a well-formatted response" do
    do_propfind(:first, @xml, :depth => 0)
    check_propget_one('addressbook_home_set')
  end
  
  it "should return the correct href" do
    do_propfind(:first, @xml, :depth => 0)

    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@principal[:href])
    
    # addressbook_href_xpath = "#{property_xpath}/#{card_ns}addressbook-home-set/#{@dav_ns}href"
    # response.xpath(addressbook_href_xpath).text.should == 'a valid path or URL'
  end
  
  it "should return a succesful result" do
    do_propfind(:first, @xml, :depth => 0)
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end