require 'rgeo/geo_json'
class ChartDataController < ApplicationController
  skip_authorization_check only: %i[geojson similarities]

  def similarities
    similarities = Similarity.order(value: :desc).includes(:broadcast1, :broadcast2)
    similarities = similarities.specific_to(current_user) if params[:specific_to_user]
    similarity_graph_data = graph_data_for(similarities.first(500))
    render json: similarity_graph_data, adapter: :attributes
  end

  def geojson
    template_feature_collection = RGeo::GeoJSON.decode(File.read(File.join(Rails.root, 'public', 'bundeslaender.geojson')), json_parser: :json)
    states = template_feature_collection.collect { |feature| feature.properties['VARNAME_1'] }
    users = User.where(country_code: 'de', state: states)
    feature_array = template_feature_collection.collect do |feature|
      properties = feature.properties
      users_in_state = users.where(state: properties['VARNAME_1'])
      properties['user_count_total'] = users_in_state.count
      properties['user_count_normalized'] = (users_in_state.count.to_f / users.count)
      RGeo::GeoJSON::Feature.new(feature.geometry, feature.feature_id, properties)
    end
    render json: RGeo::GeoJSON.encode(RGeo::GeoJSON::FeatureCollection.new(feature_array))
  end

  private

  def graph_data_for(similarities)
    broadcasts = similarities.map(&:broadcast1) + similarities.map(&:broadcast2)
    SimilarityGraph::Graph.new nodes: broadcasts.uniq, links: similarities
  end
end
