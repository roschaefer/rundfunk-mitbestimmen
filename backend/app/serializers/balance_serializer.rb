class BalanceSerializer < ActiveModel::Serializer
  attributes :id, :title, :reviews, :approval, :average, :total
end
