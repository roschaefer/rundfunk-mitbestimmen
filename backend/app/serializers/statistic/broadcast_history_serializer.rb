module Statistic
  class BroadcastHistorySerializer < ActiveModel::Serializer
    attributes :id, :title, :timestamps, :impressions, :approval, :average, :total
    type 'statistic/broadcast-histories'
  end
end
