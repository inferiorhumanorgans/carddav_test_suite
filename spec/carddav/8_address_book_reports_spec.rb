=begin
8. Address Book Reports

  This section defines the reports that CardDAV servers MUST support on
  address book collections and address object resources.

  CardDAV servers MUST advertise support for these reports on all
  address book collections and address object resources with the
  DAV:supported-report-set property defined in Section 3.1.5 of
  [RFC3253].  CardDAV servers MAY also advertise support for these
  reports on ordinary collections.

  Some of these reports allow address data (from possibly multiple
  resources) to be returned.
=end

require 'spec_helper'

describe "PROPFIND DAV:supported-report-set" do
  require_default_auth
  setup_single_property('supported-report-set', :ns_prefix => 'D')
  do_propfind(:addressbooks => :mine, :depth => 0)

  before(:all) do
    @report_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}prop/#{@dav_ns}supported-report-set/#{@dav_ns}report"
  end

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
  
  it "should include the addressbook-multiget report" do
    report_xpath = "count(#{@report_xpath}/#{@card_ns}addressbook-multiget)"
    @response.xpath(report_xpath).should eq 1
  end

  it "should include the addressbook-query report" do
    report_xpath = "count(#{@report_xpath}/#{@card_ns}addressbook-query)"
    @response.xpath(report_xpath).should eq 1
  end
end