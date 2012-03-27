module DAVClassMacros
  def require_default_auth
    before(:all) do
      @dav = Net::DAV.new(CONFIG[:base_url])
      @dav.credentials(CONFIG[:default_user], CONFIG[:default_password])
    end
  end
end