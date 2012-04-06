=begin
5.5. DAV:acl

  This is a protected property that specifies the list of access
  control entries (ACEs), which define what principals are to get what
  privileges for this resource.

  <!ELEMENT acl (ace*) >

  Each DAV:ace element specifies the set of privileges to be either
  granted or denied to a single principal.  If the DAV:acl property is
  empty, no principal is granted any privilege.

  <!ELEMENT ace ((principal | invert), (grant|deny), protected?,
                  inherited?)>
=end

require 'spec_helper'

[:principal, :addressbook].each do |resource_type|
  describe "PROPFIND DAV:acl (#{resource_type} resource)" do
    require_default_auth
    setup_single_property('acl', :ns_prefix => 'D')

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