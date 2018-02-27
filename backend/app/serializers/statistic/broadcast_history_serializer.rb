module Statistic
  class BroadcastHistorySerializer < ActiveModel::Serializer
    attributes :id, :title, :timestamps, :impressions, :approval, :average, :total
  end
end
