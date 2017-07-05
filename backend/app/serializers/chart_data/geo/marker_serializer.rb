module ChartData
  module Geo
    class MarkerSerializer < ActiveModel::Serializer
      type 'chart-data/geo/markers'
      attributes :id, :latitude, :longitude
    end
  end
end
