class ChartData::Geo::MarkerSerializer < ActiveModel::Serializer
  type 'chart-data/geo/markers'
  attributes :id, :latitude, :longitude
end
