require 'rails_helper'

RSpec.describe "ChartData::Similarities", type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:full_setup) do
    setup
    Similarity.compute_all(threshold: 0, minimum_supporters: 0)
  end
  let(:setup)  {}

  let(:action) do
    full_setup
    get url, params: params, headers: headers
  end

  describe "GET /chart_data/similarities" do
    let(:url) { chart_data_similarities_path }
    let(:graph) { JSON.parse(response.body) }

    subject do
      action
      graph
    end

    it { is_expected.to eq({'links' => [], 'nodes' => []}) }

    context 'given 3 impressions' do
      let(:setup) do
        medium = create(:medium, id: 1)
        broadcast1 = create(:broadcast, id: 21, title: 'Broadcast 1', medium: medium)
        broadcast2 = create(:broadcast, id: 22, title: 'Broadcast 2', medium: medium)
        broadcast3 = create(:broadcast, id: 23, title: 'Broadcast 3', medium: medium)
        user = create(:user)
        create(:impression, user: user, broadcast: broadcast1)
        create(:impression, user: user, broadcast: broadcast2)
        create(:impression, user: user, broadcast: broadcast3)
      end

      it 'returns 3 fully connected nodes' do
        is_expected.to eq(
       "links" => [
         {"source"=>21, "target"=>22, "value"=>"1.0"},
         {"source"=>21, "target"=>23, "value"=>"1.0"},
         {"source"=>22, "target"=>23, "value"=>"1.0"}
       ],
       "nodes" => [
         {"id"=>21, "title"=>"Broadcast 1", "group"=>1},
         {"id"=>22, "title"=>"Broadcast 2", "group"=>1},
         {"id"=>23, "title"=>"Broadcast 3", "group"=>1}
       ])
      end
    end
  end
end
