class GeocodeUserJob < ApplicationJob
  queue_as :default

  def perform(auth0_uid, access_token = nil)
    return unless auth0_uid
    user = User.find_by(auth0_uid: auth0_uid)
    return unless user
    domain = Rails.application.secrets.auth0_domain
    client_id = Rails.application.secrets.auth0_api_client_id
    client_secret = Rails.application.secrets.auth0_api_client_secret
    token = access_token || self.class.get_access_token(
      domain: domain,
      client_id: client_id,
      client_secret: client_secret
    )
    last_ip = self.class.get_user_last_ip(
      user: user,
      domain: domain,
      access_token: token
    )
    raise('No ip adress returned') unless last_ip
    geocoder_lookup = Geocoder::Lookup.get(:freegeoip)
    geocoder_result = geocoder_lookup.search(last_ip).first
    user.assign_location_attributes(geocoder_result)
    user.save
    raise('User has still no location') unless user.location?
  end

  def self.get_access_token(domain:, client_id:, client_secret:)
    audience = URI("https://#{domain}/api/v2/")
    access_token_url = URI("https://#{domain}/oauth/token")

    http = Net::HTTP.new(access_token_url.host, access_token_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Post.new(access_token_url)
    request['content-type'] = 'application/json'
    request.body = {
      grant_type: 'client_credentials',
      client_id: client_id,
      client_secret: client_secret,
      audience: audience
    }.to_json

    response = http.request(request)
    json_body = JSON.parse(response.read_body)
    case response.code
    when '401'
      raise("Create a non-interactive client for your domain #{domain.inspect}")
    when '403'
      raise("Authorize your non-interactive client for domain #{domain.inspect}")
    when '200'
      json_body['access_token']
    else
      raise("Unhandled status code: #{response.code}")
    end
  end

  def self.get_user_last_ip(user:, domain:, access_token:)
    url = URI("https://#{domain}/api/v2/users/#{CGI.escape(user.auth0_uid)}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Get.new(url)
    request['content-type'] = 'application/json'
    request['authorization'] = "Bearer #{access_token}"

    response = http.request(request)
    json_body = JSON.parse(response.read_body)
    case response.code
    when '404'
      raise("User(id: #{user.id}, auth0_uid: #{user.auth0_uid}) not found in Auth0")
    when '200'
      json_body['last_ip']
    else
      raise("Unhandled status code: #{response.code}")
    end
  end
end
