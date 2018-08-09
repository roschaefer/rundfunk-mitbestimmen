require 'rails_helper'
RSpec.describe 'ChartData', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:action) { get url, params: params, headers: headers }
  let(:states) {["Baden-Württemberg", "Bavaria", "Berlin", "Brandenburg", "Free and Hanseatic City of Bremen", "Hamburg", "Hesse", "Mecklenburg-Vorpommern", "Lower Saxony", "North Rhine-Westphalia", "Rhineland-Palatinate", "Saarland", "Saxony-Anhalt", "Saxony", "Schleswig-Holstein", "Thuringia"] }

  describe 'GET' do
    describe 'chart_data/geo/geojson' do
      let(:url) { '/chart_data/geo/geojson' }
      let(:geojson) { RGeo::GeoJSON.decode(response.body, json_parser: :json) }
      subject do
        action
        geojson
      end

      it 'returns state codes for all federal states' do
        response_states = subject.collect { |feature| feature.properties['VARNAME_1'] }
        expect(response_states).to eq(states)
      end

      context 'given users for all federal states of germany' do
        let(:users) do
          states.each_with_index do |state, i|
            create_list(:user, i, country_code: 'de', state: state)
          end
        end
        before { users }

        it 'returns counts for all federal states' do
          counts = subject.collect { |feature| feature.properties['user_count_total'] }
          expect(counts).to eq((0..15).to_a)
        end

        it 'returns normalized counts for all federal states' do
          normalized_counts = subject.collect { |feature| feature.properties['user_count_normalized'] }
          expect(normalized_counts).to all(be_between(0, 1))
        end
      end
    end
  end
end
