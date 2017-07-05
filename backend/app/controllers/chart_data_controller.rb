class ChartDataController < ApplicationController
  skip_authorization_check only: %i[diff geo]

  def diff
    actual_distribution = Station.joins(broadcasts: :statistic).group('"stations"."name"').sum(:total)
    actual_distribution.default = '0.0'
    broadcasts_with_stations = Broadcast.where.not(station: nil)
    per_broadcast = broadcasts_with_stations.joins(:selections).sum(:amount) / broadcasts_with_stations.count
    uniform_expectation = Station.joins(:broadcasts).group('"stations"."name"').count
    uniform_expectation = uniform_expectation.update(uniform_expectation) { |_k, v| v * per_broadcast }

    series = [
      { 'name' => I18n.t('chart_data.diff.series.actual'), 'data' => [] },
      { 'name' => I18n.t('chart_data.diff.series.uniform'), 'data' => [] }
    ]
    categories = uniform_expectation.keys.sort

    categories.each do |station_name|
      series[0]['data'] << actual_distribution[station_name]
      series[1]['data'] << uniform_expectation[station_name]
    end

    diff_chart = ChartData::Diff.new(series: series, categories: categories)
    render json: diff_chart
  end

  def geo
    render json: User.where.not(latitude: nil, longitude: nil), each_serializer: ChartData::Geo::MarkerSerializer
  end
end
