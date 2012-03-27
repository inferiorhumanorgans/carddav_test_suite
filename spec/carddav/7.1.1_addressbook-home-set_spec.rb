require 'spec_helper'

describe "PROPFIND addressbook-home-set" do
  require_default_auth

  it "should return a well-formatted response" do
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
    
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.propfind('xmlns:D' => 'DAV:', 'xmlns:C' => 'urn:ietf:params:xml:ns:carddav') do
        xml.parent.namespace = xml.parent.namespace_definitions.find{|ns|ns.prefix=="D"}
        xml['D'].prop do
          xml['C'].send 'addressbook-home-set'
        end
      end
    end

    do_propfind(:first, xml, :depth => 0)
    check_propget_one('addressbook_home_set')

    dav_ns = ns()
    card_ns = ns('urn:ietf:params:xml:ns:carddav')

    response_xpath = "/#{dav_ns}multistatus/#{dav_ns}response"
    response_href_xpath = "#{response_xpath}/#{dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@principal[:href])
    
    # addressbook_href_xpath = "#{property_xpath}/#{card_ns}addressbook-home-set/#{dav_ns}href"
    # response.xpath(addressbook_href_xpath).text.should == 'a valid path or URL'
    
    status_xpath = "#{response_xpath}/#{dav_ns}propstat/#{dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end