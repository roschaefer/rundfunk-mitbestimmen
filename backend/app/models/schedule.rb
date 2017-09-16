class Schedule < ApplicationRecord
  belongs_to :broadcast
  belongs_to :station, counter_cache: :broadcasts_count
end
