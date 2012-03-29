module PropfindClassMacros

  def setup_single_property(prop, prop_ns='C')
    before(:all) do
      @prop = prop
      @namespaces = {'xmlns:D' => 'DAV:', 'xmlns:C' => 'urn:ietf:params:xml:ns:carddav', 'xmlns:APPLE1' => 'http://calendarserver.org/ns/'}
      @xml = Nokogiri::XML::Builder.new do |xml|
        xml.propfind(@namespaces) do
          xml.parent.namespace = xml.parent.namespace_definitions.find{|ns|ns.prefix=="D"}
          xml['D'].prop do
            xml[prop_ns].send prop
          end
        end
      end
    end
  end

end

