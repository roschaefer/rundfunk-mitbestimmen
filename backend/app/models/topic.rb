class Topic < ApplicationRecord
  translates :name
  globalize_accessors
  has_many :broadcasts
end
