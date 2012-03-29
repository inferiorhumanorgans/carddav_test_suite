require 'spec_helper'

describe "PROPFIND getetag" do
  require_default_auth

  setup_single_property('getetag', 'D')

  it "should return a well-formatted response" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)
    check_propget_one(@prop)
  end

  it "should return the correct href" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)

    response_href_xpath = "#{@response_xpath}/#{@dav_ns}href"

    # This is ugly, but I suppose not including a trailing slash isn't a cardinal sin
    @response.xpath(response_href_xpath).text.should be_similar_to_href(@addressbook[:href])
  end
  
  it "should return a succesful result" do
    do_propfind(@xml, :addressbooks => :mine, :depth => 0)
    status_xpath = "#{@response_xpath}/#{@dav_ns}propstat/#{@dav_ns}status"
    @response.xpath(status_xpath).text.should be_success
  end
end