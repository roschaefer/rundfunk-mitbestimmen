class Medium < ApplicationRecord
  translates :name
  globalize_accessors
  attribute :name
  has_many :broadcasts
  has_many :stations
end
