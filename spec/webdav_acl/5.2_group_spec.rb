=begin
5.2. DAV:group

  This property identifies a particular principal as being the "group"
  of the resource.  This property is commonly found on repositories
  that implement the Unix privileges model.

  Servers MAY implement DAV:group as protected property and MAY return
  an empty DAV:group element as property value in case no group
  information is available.

  <!ELEMENT group (href?)>
=end

require 'spec_helper'

[:principal, :addressbook].each do |resource_type|

  describe "PROPFIND DAV:group (#{resource_type} resource)" do
    require_default_auth
    setup_single_property('group', :ns_prefix => 'D')

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