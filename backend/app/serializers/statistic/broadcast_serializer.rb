module Statistic
  class BroadcastSerializer < ActiveModel::Serializer
    attributes :id, :title, :impressions, :approval, :average, :total
  end
end
