class CreateStatistics < ActiveRecord::Migration
  def change
    create_view :statistics
  end
end
