module PropfindClassMacros

  def setup_single_property(prop)
    before(:all) do
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.propfind('xmlns:D' => 'DAV:', 'xmlns:C' => 'urn:ietf:params:xml:ns:carddav') do
          xml.parent.namespace = xml.parent.namespace_definitions.find{|ns|ns.prefix=="D"}
          xml['D'].prop do
            xml['C'].send prop
          end
        end
      end
    end
  end

end

