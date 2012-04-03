module PropfindInstanceMacros

  def do_propfind(xml, options)
    if options.include? :principals
      @principal = @obj = CONFIG[:principals][options[:principals]]
    elsif options.include? :addressbooks
      @addressbook = @obj = CONFIG[:addressbooks][options[:addressbooks]]
    end

    dav_opts = options
    dav_opts.delete :principals
    dav_opts.delete :addressbooks

    @response = @dav.propfind(@obj[:href], xml.to_xml, dav_opts)
    get_namespaces
    @response_xpath = "/#{@dav_ns}multistatus/#{@dav_ns}response"
  end

  # Check the XML response for a PROPFIND where only one property has been requested.
  def check_propget_one(type, options={})
    opts = {:xsd_prefix => ''}.merge(options)

    @response.should be_kind_of(Nokogiri::XML::Document)

    xsd_path = File.join(XML_PATH.join("propget_one_#{opts[:xsd_prefix]}#{type}.xsd"))
    xsd = Nokogiri::XML::Schema(IO.read(xsd_path))
    xsd.validate(@response).should successfully_validate
  end

end