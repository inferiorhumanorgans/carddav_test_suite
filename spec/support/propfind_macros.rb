module PropfindMacros

  def do_propfind(principal, xml, *options)
    @principal = CONFIG[:principals][principal]
    @response = @dav.propfind(@principal[:href], xml.to_xml, *options)
    get_namespaces
    @response_xpath = "/#{@dav_ns}multistatus/#{@dav_ns}response"
  end

  def check_propget_one(type)
    @response.should be_kind_of(Nokogiri::XML::Document)

    xsd_path = File.join(XML_PATH.join('propget_one.xsd'))
    xsd = Nokogiri::XML(IO.read(xsd_path))

    xsl_path = File.join(XML_PATH.join("propget_one_#{type}.xsl"))
    xsl = Nokogiri::XSLT(IO.read(xsl_path))

    xsd = Nokogiri::XML::Schema(xsl.apply_to(xsd))
    xsd.validate(@response).should successfully_validate
  end

end