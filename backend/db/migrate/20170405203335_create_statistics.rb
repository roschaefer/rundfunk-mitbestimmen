class CreateStatistics < ActiveRecord::Migration[5.0]
  def change
    create_view :statistics
  end
end
