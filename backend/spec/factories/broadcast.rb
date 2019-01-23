FactoryBot.define do
  factory :broadcast do
    sequence :title do |n|
      "Super broadcast ##{n}"
    end
    description { 'This nice little description is usually what users of the app need to know in order to decide whether they like the broadcast or not' }
    medium
  end
end
