module DAVInstanceMacros
  def do_propfind(principal, xml, *options)
    @principal = CONFIG[:principals][principal]
    @response = @dav.propfind(@principal[:href], xml.to_xml, *options)
  end
end