require 'spec_helper'

describe "Principal Resource" do
  require_default_auth
  
  it "should handle a bogus propfind w/o a 500 error" do

    xml = Nokogiri::XML::Builder.new
    xml.propfind('xmlns:D' => 'DAV:', 'xmlns:C' => 'urn:ietf:params:xml:ns:carddav') do
      xml['D'].prop do
        xml['C'].random_tag_that_does_not_exist
      end
    end

    do_propfind(:first, xml)
    @response.should be_kind_of(Nokogiri::XML::Document)
  end
end