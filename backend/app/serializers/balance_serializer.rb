class BalanceSerializer < ActiveModel::Serializer
  attributes :id, :title, :votes, :approval, :average, :total
end
