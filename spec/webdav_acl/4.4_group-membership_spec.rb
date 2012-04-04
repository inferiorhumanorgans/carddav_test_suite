=begin
4.4. DAV:group-membership

  This protected property identifies the groups in which the principal
  is directly a member.  Note that a server may allow a group to be a
  member of another group, in which case the DAV:group-membership of
  those other groups would need to be queried in order to determine the
  groups in which the principal is indirectly a member.  Support for
  this property is REQUIRED.

  <!ELEMENT group-membership (href*)>\
=end

require 'spec_helper'

describe "PROPFIND group-membership (principal resource)" do
  require_default_auth
  setup_single_property('group-membership', :ns_prefix => 'D')
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