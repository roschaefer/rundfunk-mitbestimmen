class BroadcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at

  has_many :impressions do
    object.impressions.where(user: scope)
  end
  belongs_to :medium
  belongs_to :station
end
