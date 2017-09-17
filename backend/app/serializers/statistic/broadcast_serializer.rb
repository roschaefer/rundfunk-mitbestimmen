module Statistic
  class BroadcastSerializer < ActiveModel::Serializer
    attributes :id, :title, :impressions, :approval, :average, :total
    type 'statistic/broadcasts'
  end
end
