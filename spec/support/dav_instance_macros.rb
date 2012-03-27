module DAVInstanceMacros
  
  def get_namespaces
    @dav_ns = ns()
    @card_ns = ns('urn:ietf:params:xml:ns:carddav')
  end

  def ns(uri='DAV:')
    r = @response.root.namespace_definitions.select{|ns| ns.href == uri}.first.prefix.to_s
    r += ':' unless r.empty?
    r
  end

end