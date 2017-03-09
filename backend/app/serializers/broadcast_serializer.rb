class BroadcastSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :selections do
    object.selections.where(user: scope)
  end
  belongs_to :medium
  belongs_to :station
end
