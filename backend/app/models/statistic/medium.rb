module Statistic
  class Medium < ApplicationRecord
    translates :name
    globalize_accessors
    attribute :name

    self.primary_key = :id
    belongs_to :medium, class_name: '::Medium', foreign_key: :id
    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
