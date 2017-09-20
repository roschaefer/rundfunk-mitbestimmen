class Statistic::StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :broadcasts_count, :total, :expected_amount
  type 'statistic/stations'
end
