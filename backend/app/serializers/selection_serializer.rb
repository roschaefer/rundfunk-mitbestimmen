class SelectionSerializer < ActiveModel::Serializer
  attributes :id, :response, :amount, :fixed
  has_one :user
  has_one :broadcast
end
