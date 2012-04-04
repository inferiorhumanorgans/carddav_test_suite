=begin
4.2. DAV:principal-URL

  A principal may have many URLs, but there must be one "principal URL"
  that clients can use to uniquely identify a principal.  This
  protected property contains the URL that MUST be used to identify
  this principal in an ACL request.  Support for this property is
  REQUIRED.

  <!ELEMENT principal-URL (href)>
=end

require 'spec_helper'

describe "PROPFIND DAV:principal-URL (principal resource)" do
  require_default_auth
  setup_single_property('principal-URL', :ns_prefix => 'D')
  do_propfind(:principals => :first, :depth => 0)

  it "should return a well-formatted response" do
    check_propget_one(@prop)
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