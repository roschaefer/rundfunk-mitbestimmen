FactoryBot.define do
  factory :similarity do
    broadcast1 factory: :broadcast
    broadcast2 factory: :broadcast
    value { 1 }
  end
end
