class Format < ApplicationRecord
  translates :name
  globalize_accessors
  attribute :name
  has_many :broadcasts
end
