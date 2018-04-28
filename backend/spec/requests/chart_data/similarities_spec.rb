require 'rails_helper'

RSpec.describe 'ChartData::Similarities', type: :request do
  let(:headers) { {} }
  let(:params)  { {} }
  let(:full_setup) do
    setup
  end
  let(:setup)  {}

  let(:action) do
    full_setup
    get url, params: params, headers: headers
  end

  describe 'GET /chart_data/similarities' do
    let(:url) { chart_data_similarities_path }
    let(:graph) { JSON.parse(response.body) }

    subject do
      action
      graph
    end

    it { is_expected.to eq('data' => { 'links' => [], 'nodes' => [] }) }

    context 'given 3 similarities' do
      let(:user) { create(:user, id: 1) }
      let(:setup) do
        medium = create(:medium, id: 1)
        broadcast1 = create(:broadcast, id: 21, title: 'Broadcast 1', medium: medium)
        broadcast2 = create(:broadcast, id: 22, title: 'Broadcast 2', medium: medium)
        broadcast3 = create(:broadcast, id: 23, title: 'Broadcast 3', medium: medium)
        create(:similarity, broadcast1: broadcast1, broadcast2: broadcast2, value: 1)
        create(:similarity, broadcast1: broadcast1, broadcast2: broadcast3, value: 1)
        create(:similarity, broadcast1: broadcast2, broadcast2: broadcast3, value: 1)
        create(:impression, user: user, broadcast: broadcast1, response: :positive)
        create(:impression, user: user, broadcast: broadcast2, response: :neutral)
      end

      it 'returns 3 fully connected nodes' do
        is_expected.to eq(
          'data' =>
          {
            'links' => [
              { 'source' => 21, 'target' => 22, 'value' => '1.0' },
              { 'source' => 21, 'target' => 23, 'value' => '1.0' },
              { 'source' => 22, 'target' => 23, 'value' => '1.0' }
            ],
            'nodes' => [
              { 'id' => 21, 'title' => 'Broadcast 1', 'group' => 1 },
              { 'id' => 22, 'title' => 'Broadcast 2', 'group' => 1 },
              { 'id' => 23, 'title' => 'Broadcast 3', 'group' => 1 }
            ]
          }
        )
      end

      context 'a specific_to_user is provided' do
        let(:url) { chart_data_similarities_path(specific_to_user: true, headers: headers) }

        context('the user is not authenticated') do
          it { is_expected.to eq('data' => { 'links' => [], 'nodes' => [] }) }
        end

        context('the user is authenticated') do
          let(:headers) do
            user.auth0_uid = 'email|58d072bf0bdcab0a0ecee8ad'
            super().merge(authenticated_header(user))
          end

          let(:user) do
            User.skip_callback(:save, :after, :geocode_last_ip)
            user = create(:user, :without_geolocation, auth0_uid: nil)
            User.set_callback(:save, :after, :geocode_last_ip)
            user
          end

          before { user }

          it 'returns only similarities connected to user supported broadcasts' do
            is_expected.to eq(
              'data' =>
              {
                'links' => [
                  { 'source' => 21, 'target' => 22, 'value' => '1.0' },
                  { 'source' => 21, 'target' => 23, 'value' => '1.0' }
                ],
                'nodes' => [
                  { 'id' => 21, 'title' => 'Broadcast 1', 'group' => 1 },
                  { 'id' => 22, 'title' => 'Broadcast 2', 'group' => 1 },
                  { 'id' => 23, 'title' => 'Broadcast 3', 'group' => 1 }
                ]
              }
            )
          end
        end
      end
    end
  end
end
