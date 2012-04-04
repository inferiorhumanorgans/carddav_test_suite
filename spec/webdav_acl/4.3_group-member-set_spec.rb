=begin
4.3. DAV:group-member-set

  This property of a group principal identifies the principals that are
  direct members of this group.  Since a group may be a member of
  another group, a group may also have indirect members (i.e., the
  members of its direct members).  A URL in the DAV:group-member-set
  for a principal MUST be the DAV:principal-URL of that principal.

  <!ELEMENT group-member-set (href*)>
=end

require 'spec_helper'

describe "PROPFIND DAV:group-membership-set (principal resource)" do
  require_default_auth
  setup_single_property('group-membership-set', :ns_prefix => 'D')
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