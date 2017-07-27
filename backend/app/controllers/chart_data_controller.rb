require 'rgeo/geo_json'
class ChartDataController < ApplicationController
  skip_authorization_check only: %i[diff location geojson]

  def diff
    actual_distribution = Station.joins(broadcasts: :statistic).group('"stations"."name"').sum(:total)
    actual_distribution.default = '0.0'
    broadcasts_with_stations = Broadcast.where.not(station: nil)

    total_amount = broadcasts_with_stations.joins(:selections).sum(:amount)
    total_number_of_selections = broadcasts_with_stations.joins(:selections).count
    amount_per_broadcast =  total_amount / total_number_of_selections

    broadcasts_per_station = Station.joins(:broadcasts).group('"stations"."name"').count
    stations_with_selections = Station.joins(:selections).each.collect { |s| s.name }

    uniform_expectation = {}
    uniform_expectation.default = '0.0'
    broadcasts_per_station.each.map do |k, v|
      if stations_with_selections.include?(k)
       uniform_expectation.update({k => (v * amount_per_broadcast).round(4)})
      end
    end

    series = [
      { 'name' => I18n.t('chart_data.diff.series.actual'), 'data' => [] },
      { 'name' => I18n.t('chart_data.diff.series.expected'), 'data' => [] }
    ]
    categories = broadcasts_per_station.keys.sort #stations_with_selections.sort

    categories.each do |station_name|
      series[0]['data'] << actual_distribution[station_name]
      series[1]['data'] << uniform_expectation[station_name]
    end

    diff_chart = ChartData::Diff.new(series: series, categories: categories)
    render json: diff_chart
  end

  def location
    locations = []
    locations << current_user if current_user && current_user.location?
    render json: locations, each_serializer: ChartData::Geo::LocationSerializer
  end

  def geojson
    template_feature_collection = RGeo::GeoJSON.decode(File.read(File.join(Rails.root, 'public', 'bundeslaender.geojson')), json_parser: :json)
    state_codes = template_feature_collection.collect { |feature| feature.properties['state_code'] }
    users = User.where(country_code: 'DE', state_code: state_codes)
    feature_array = template_feature_collection.collect do |feature|
      properties = feature.properties
      users_in_state = users.where(state_code: properties['state_code'])
      properties['user_count_total'] = users_in_state.count
      properties['user_count_normalized'] = (users_in_state.count.to_f / users.count.to_f)
      RGeo::GeoJSON::Feature.new(feature.geometry, feature.feature_id, properties)
    end
    render json: RGeo::GeoJSON.encode(RGeo::GeoJSON::FeatureCollection.new(feature_array))
  end
end
