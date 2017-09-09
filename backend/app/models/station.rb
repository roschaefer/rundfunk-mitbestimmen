class Station < ApplicationRecord
  belongs_to :medium
  has_many :broadcasts
  has_many :impressions, through: :broadcasts
  attribute :name
  validates :medium, presence: true
  validates :name, uniqueness: true
end
