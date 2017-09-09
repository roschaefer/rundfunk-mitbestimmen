class StatisticSerializer < ActiveModel::Serializer
  attributes :id, :title, :impressions, :approval, :average, :total
end
