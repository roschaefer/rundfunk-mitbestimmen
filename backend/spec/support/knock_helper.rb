module KnockHelper
  def authenticated_header(user)
    token = Knock::AuthToken.new(payload: { email: user.email, sub: user.auth0_uid}).token

    {
      'Authorization': "Bearer #{token}"
    }
  end
end
