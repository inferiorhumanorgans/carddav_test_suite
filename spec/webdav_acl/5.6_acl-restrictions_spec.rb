=begin
5.6. DAV:acl-restrictions

  This protected property defines the types of ACLs supported by this
  server, to avoid clients needlessly getting errors.  When a client
  tries to set an ACL via the ACL method, the server may reject the
  attempt to set the ACL as specified.  The following properties
  indicate the restrictions the client must observe before setting an
  ACL:

  <grant-only> Deny ACEs are not supported

  <no-invert> Inverted ACEs are not supported

  <deny-before-grant> All deny ACEs must occur before any grant ACEs

  <required-principal> Indicates which principals are required to be
    present


  <!ELEMENT acl-restrictions (grant-only?, no-invert?,
                              deny-before-grant?,
                              required-principal?)>
=end

require 'spec_helper'

[:principal, :addressbook].each do |resource_type|
  describe "PROPFIND DAV:acl-restrictions (#{resource_type} resource)" do
    require_default_auth
    setup_single_property('acl-restrictions', :ns_prefix => 'D')

    case resource_type
    when :principal then
      do_propfind(:principals => :first, :depth => 0)
      before(:all) do
        @object = @principal
      end
    when :addressbook
      do_propfind(:addressbooks => :mine, :depth => 0)
      before(:all) do
        @object = @addressbook
      end
    end

    it "should return a well-formatted response" do
      check_propget_one(@prop)
    end

    it "should return the correct href" do
      response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

      # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
      @response.xpath(response_href_xpath).text.should be_similar_to_href(@object[:href])
    end

    it "should return a succesful result" do
      status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
      @response.xpath(status_xpath).text.should be_success
    end
  end
end