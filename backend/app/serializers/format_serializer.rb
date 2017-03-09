class FormatSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :broadcasts
end
