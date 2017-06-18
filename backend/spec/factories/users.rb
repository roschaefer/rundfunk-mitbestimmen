FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "john.doe#{n}@example.org" }
    sequence(:auth0_uid) { |n| "auth0|#{n}#{('a'..'z').to_a.shuffle.join}" }

    # has a location by default, avoid unnecessary requests in tests
    latitude 21
    longitude 22

    trait :without_geolocation do
      latitude nil
      longitude nil
    end

    trait :admin do
      role :admin
    end

    trait :contributor do
      role :contributor
    end

    trait :guest do
      role :guest
    end
  end
end
