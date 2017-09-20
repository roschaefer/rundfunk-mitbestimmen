module Statistic
  class Medium < ApplicationRecord
    self.primary_key = :id
    belongs_to :station, class_name: '::Station', foreign_key: :id
    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
