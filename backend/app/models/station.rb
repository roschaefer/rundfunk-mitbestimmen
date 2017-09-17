class Station < ApplicationRecord
  belongs_to :medium
  has_many :schedules
  has_many :broadcasts, through: :schedules
  has_many :impressions, through: :broadcasts
  has_one :statistic, class_name: 'Statistic::Station', foreign_key: :id
  attribute :name
  validates :medium, presence: true
  validates :name, uniqueness: true

  before_update :reset_broadcasts_count

  private

  def reset_broadcasts_count
    Station.reset_counters(id, :schedules)
  end
end
