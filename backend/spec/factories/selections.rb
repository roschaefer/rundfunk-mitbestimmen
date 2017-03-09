FactoryGirl.define do
  factory :selection do
    response 1
    association(:user)
    association(:broadcast)
  end
end
