class CreateStatisticKpis < ActiveRecord::Migration[5.0]
  def change
    create_view :statistic_kpis
  end
end
