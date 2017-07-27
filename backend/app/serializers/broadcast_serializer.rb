class BroadcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at

  has_many :selections do
    object.selections.where(user: scope)
  end
  belongs_to :medium
  belongs_to :station
end
