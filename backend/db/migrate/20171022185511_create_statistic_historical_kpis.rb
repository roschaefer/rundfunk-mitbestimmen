class CreateStatisticHistoricalKpis < ActiveRecord::Migration[5.0]
  def change
    create_view :statistic_historical_kpis
  end
end
