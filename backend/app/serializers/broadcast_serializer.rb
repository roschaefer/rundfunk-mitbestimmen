class BroadcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image_url, :created_at, :updated_at

  has_many :impressions do
    object.impressions.where(user: scope)
  end
  belongs_to :medium
  has_many :stations
end
