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

  def do_propfind(options)
    before(:all) do
      if options.include? :principals
        @principal = @obj = CONFIG[:principals][options[:principals]]
      elsif options.include? :addressbooks
        @addressbook = @obj = CONFIG[:addressbooks][options[:addressbooks]]
      end

      dav_opts = options
      dav_opts.delete :principals
      dav_opts.delete :addressbooks

      @response = @dav.propfind(@obj[:href], @xml.to_xml, dav_opts)
      get_namespaces
      @response_xpath = "/#{@dav_ns}multistatus/#{@dav_ns}response"
    end
  end

end

