module TokenStubs
  def stub_jwt(user)
    token = Knock::AuthToken.new(payload: { email: user.email, sub: user.auth0_uid}).token
    page.evaluate_script("window.stubbedJwt = '#{token}'")
  end
end
World(TokenStubs)
