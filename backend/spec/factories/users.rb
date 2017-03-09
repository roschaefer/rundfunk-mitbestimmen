FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "john.doe#{n}@example.org" }
    sequence(:auth0_uid) { |n| "auth0|#{n}#{('a'..'z').to_a.shuffle.join}" }

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
