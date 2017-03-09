class Station < ApplicationRecord
  belongs_to :medium
  has_many :broadcasts

  validates :medium, presence: true
end
