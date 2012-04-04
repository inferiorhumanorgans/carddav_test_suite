=begin
4.1. DAV:alternate-URI-set

  This protected property, if non-empty, contains the URIs of network
  resources with additional descriptive information about the
  principal.  This property identifies additional network resources
  (i.e., it contains one or more URIs) that may be consulted by a
  client to gain additional knowledge concerning a principal.  One
  expected use for this property is the storage of an LDAP [RFC2255]
  scheme URL.  A user-agent encountering an LDAP URL could use LDAP
  [RFC2251] to retrieve additional machine-readable directory
  information about the principal, and display that information in its
  user interface.  Support for this property is REQUIRED, and the value
  is empty if no alternate URI exists for the principal.

  <!ELEMENT alternate-URI-set (href*)>
=end

require 'spec_helper'

describe "PROPFIND DAV:alternate-URI-set (principal resource)" do
  require_default_auth
  setup_single_property('alternate-URI-set', :ns_prefix => 'D')
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