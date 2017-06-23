namespace :geocode do
  namespace :auth0 do
    desc 'Geocode users based on their last ip address in Auth0'
    task last_ip: :environment do
      user_relation = User.where(latitude: nil, longitude: nil).where.not(auth0_uid: nil)
      puts "About to geocode #{user_relation.count} users"
      user_relation.find_each do |user|
        GeocodeUserJob.perform_later(user.auth0_uid)
      end
    end
  end
end
