module Statistic
  class HistoricalKpi < ApplicationRecord
    self.primary_key = :id
    paginates_per 10
    belongs_to :broadcast, class_name: '::Broadcast', foreign_key: :id

    scope :as_of, ->(date) { unscoped.where("'#{date.utc}'::timestamp <@ validity") }

    # impressions count * average amount per selection
    def expected_amount(date: Time.now)
      if impressions.nil? || Impression.average_amount_per_selection(date).nil?
        nil
      else
        impressions * Impression.average_amount_per_selection(date)
      end
    end

    private

    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
