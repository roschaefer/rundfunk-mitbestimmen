class Schedule < ApplicationRecord
  has_paper_trail
  belongs_to :broadcast
  belongs_to :station, counter_cache: :broadcasts_count

  validates :broadcast, uniqueness: { scope: :station }
end
