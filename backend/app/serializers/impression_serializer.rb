class ImpressionSerializer < ActiveModel::Serializer
  attributes :id, :response, :amount, :fixed, :updated_at, :created_at
  has_one :user
  has_one :broadcast
end
