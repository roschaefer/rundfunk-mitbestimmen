class Statistic::Station < ApplicationRecord
  self.primary_key = :id
  belongs_to :station, foreign_key: :id
  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end
end
