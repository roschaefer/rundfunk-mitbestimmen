module Statistic
  class Kpi < ApplicationRecord
    self.primary_key = :id
    paginates_per 10

    belongs_to :broadcast, class_name: '::Kpi', foreign_key: :id

    scope :as_of, -> (date) { unscoped.where("'#{date.utc}'::timestamp <@ validity")}

    def self.default_scope
      as_of(Time.now.utc)
    end

    private

    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
