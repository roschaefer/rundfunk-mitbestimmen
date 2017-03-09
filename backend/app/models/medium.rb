class Medium < ApplicationRecord
  translates :name
  globalize_accessors
  has_many :broadcasts
  has_many :stations
end
