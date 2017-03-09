class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :broadcasts_count
  has_one :medium
end
