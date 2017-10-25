FactoryBot.define do
  factory :impression do
    response 1
    association(:user)
    association(:broadcast)
  end
end
