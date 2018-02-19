require 'rgeo/geo_json'
class ChartDataController < ApplicationController
  skip_authorization_check only: [:geojson, :similarities]


  def similarities
    broadcasts = []
    edges = []
    Similarity.find_each do |s|
      broadcasts << s.broadcast1
      broadcasts << s.broadcast2
      edges << {source: s.broadcast1.title, target: s.broadcast2.title, value: s.value}
    end
    nodes = broadcasts.uniq.map {|broadcast| {id: broadcast.title, group: broadcast.medium.id}}
    render json: {nodes: nodes, links: edges}
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
