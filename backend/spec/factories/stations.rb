FactoryGirl.define do
  factory :station do
    sequence(:name) { |i| "MyStation #{i}" }
    medium
  end
end
