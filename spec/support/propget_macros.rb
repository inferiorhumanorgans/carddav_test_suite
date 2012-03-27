module PropgetMacros
  XML_PATH = Pathname.new(Dir.pwd).join('xml')

  def check_propget_one(type)
    @response.should be_kind_of(Nokogiri::XML::Document)

    xsd_path = File.join(XML_PATH.join('propget_one.xsd'))
    xsd = Nokogiri::XML(IO.read(xsd_path))

    xsl_path = File.join(XML_PATH.join("propget_one_#{type}.xsl"))
    xsl = Nokogiri::XSLT(IO.read(xsl_path))

    xsd = Nokogiri::XML::Schema(xsl.apply_to(xsd))
    xsd.validate(@response).should successfully_validate
  end
  
  def ns(uri='DAV:')
    r = @response.root.namespace_definitions.select{|ns| ns.href == uri}.first.prefix.to_s
    r += ':' unless r.empty?
    r
  end
end