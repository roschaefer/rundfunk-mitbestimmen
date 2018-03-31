class Calendar < ApplicationRecord
  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end

  belongs_to :artist
end
