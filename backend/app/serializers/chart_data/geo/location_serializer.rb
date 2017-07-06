module ChartData
  module Geo
    class LocationSerializer < ActiveModel::Serializer
      type 'chart-data/geo/location'
      attributes :id, :latitude, :longitude, :country_code, :state_code, :city, :postal_code
    end
  end
end
