require 'spec_helper'

describe "Principal Resource" do
  require_default_auth
  
  it "should handle a bogus propfind like a bad request" do

    xml = Nokogiri::XML::Builder.new
    xml.propfind('xmlns:D' => 'DAV:', 'xmlns:C' => 'urn:ietf:params:xml:ns:carddav') do
      xml['D'].prop do
        xml['C'].random_tag_that_does_not_exist
      end
    end

    # This is probably really implementation specific.
    expect {do_propfind(xml, :principals => :first)}.to raise_exception(Net::HTTPServerException) do |ex|
      ex.data.should be_kind_of Net::HTTPBadRequest
    end
  end
end