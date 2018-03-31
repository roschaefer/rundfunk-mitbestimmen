class CreateCalendars < ActiveRecord::Migration[5.1]
  def change
    create_view :calendars
  end
end
