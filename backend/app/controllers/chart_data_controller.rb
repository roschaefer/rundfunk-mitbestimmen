require 'rgeo/geo_json'
class ChartDataController < ApplicationController
  skip_authorization_check only: %i[diff location geojson]

  def diff
    medium_id = params[:medium_id]
    base_query = Station.where(medium_id: medium_id).left_joins(broadcasts: :statistic).group('"stations"."name"').order('"stations"."name"')
    results = base_query.pluck('name', 'SUM(CASE WHEN total IS NOT NULL THEN 1 ELSE 0 END)', 'SUM(total)', 'SUM(expected_amount)').transpose
    results = [[], [], [], []] if results.empty?
    categories = results[0]
    number_of_broadcasts = results[1].map(&:to_f)

    # to_f turns nil into 0.0 and rounds 0.999999999 to 1
    actual_amounts = results[2].map(&:to_f)
    expected_amounts = results[3].map(&:to_f)

    series = [
      {
        'name' => I18n.t('chart_data.diff.series.actual'),
        'data' => actual_amounts
      }, {
        'name' => I18n.t('chart_data.diff.series.expected'),
        'data' => expected_amounts
      }, {
        'name' => I18n.t('chart_data.diff.series.number_of_broadcasts'),
        'data' => number_of_broadcasts
      }
    ]
    diff_chart = ChartData::Diff.new(id: medium_id, series: series, categories: categories)
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
