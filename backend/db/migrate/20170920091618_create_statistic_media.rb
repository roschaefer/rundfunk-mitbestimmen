class CreateStatisticMedia < ActiveRecord::Migration[5.0]
  def change
    create_view :statistic_media
  end
end
