namespace :geocode do
  namespace :auth0 do
    def get_access_token(domain:, client_id:, client_secret:)
      audience = URI("https://#{domain}/api/v2/")
      access_token_url = URI("https://#{domain}/oauth/token")

      http = Net::HTTP.new(access_token_url.host, access_token_url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

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
        abort("Create a non-interactive client for your domain #{domain.inspect}")
      when '403'
        abort("Authorize your non-interactive client for domain #{domain.inspect}")
      when '200'
        json_body['access_token']
      else
        abort("Unhandled status code: #{response.code}")
      end
    end

    def get_user_last_ip(user:, domain:, access_token:)
      url = URI("https://#{domain}/api/v2/users/#{URI.escape(user.auth0_uid)}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['content-type'] = 'application/json'
      request['authorization'] = "Bearer #{access_token}"

      response = http.request(request)
      json_body = JSON.parse(response.read_body)
      case response.code
      when '404'
        puts "User(id: #{user.id}, auth0_uid: #{user.auth0_uid}) not found in Auth0"
        nil
      when '200'
        json_body['last_ip']
      else
        abort("Unhandled status code: #{response.code}")
      end
    end

    desc 'Geocode users based on their last ip address in Auth0'
    task last_ip: :environment do
      domain = ENV['AUTH0_DOMAIN'] # 'rundfunk-testing.eu.auth0.com'
      client_id = ENV['AUTH0_API_CLIENT_ID'] # 'YeAqKKICU4HSLt3ECfdid2gEAcAdzdE4'
      client_secret = ENV['AUTH0_API_CLIENT_SECRET'] # 'fn3ErQZRDslgpmo-Jnv8oD29iEw5RIYQbfj4YQby-wcUm_3d31BbLfDSLoJsdFRW'
      (domain && client_id && client_id) || abort('Configure your environment variables')
      access_token = get_access_token(domain: domain, client_id: client_id, client_secret: client_secret)

      user_relation = User.where(latitude: nil, longitude: nil).where.not(auth0_uid: nil)
      puts "About to geocode #{user_relation.count} users"

      user_relation.find_each do |user|
        last_ip = get_user_last_ip(user: user, domain: domain, access_token: access_token)
        geocoder_lookup = Geocoder::Lookup.get(:freegeoip)
        geocoder_result = geocoder_lookup.search(last_ip).first
        user.update_location(geocoder_result)
      end
    end
  end
end
