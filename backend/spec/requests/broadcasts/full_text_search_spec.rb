require 'rails_helper'

RSpec.describe 'Broadcasts::FullTextSearch', type: :request do
  describe 'GET /broadcasts' do
    let(:url) { '/broadcasts' }
    let(:action) { get url, params: params, headers: headers }
    let(:params) { { q: query } }

    before do
      setup
      action
    end

    context 'given a broadcast' do
      let(:haystack) { create_list(:broadcast, 5) }
      let(:setup) do
        haystack
        needle
      end

      describe '?q=' do
        describe 'query is substring of title' do
          let(:needle) { create(:broadcast, title: 'This is an interesting broadcast, find me') }
          let(:query) { 'find me' }
          specify { expect(parse_json(response.body, 'data/0/attributes/title')).to eq 'This is an interesting broadcast, find me' }
          specify { expect(response.body).to have_json_size(1).at_path('data') }
        end

        describe 'case sensitivity' do
          let(:needle) { create(:broadcast, title: 'This is an interesting broadcast, find me') }
          let(:query) { 'Find Me' }
          describe 'does not matter' do
            specify { expect(parse_json(response.body, 'data/0/attributes/title')).to eq 'This is an interesting broadcast, find me' }
            specify { expect(response.body).to have_json_size(1).at_path('data') }
          end
        end

        describe 'extra whitespaces' do
          let(:needle) { create(:broadcast, title: 'This is an interesting broadcast, find me') }
          let(:query) { "    find  \t   me  \n  " }
          describe 'are removed' do
            specify { expect(parse_json(response.body, 'data/0/attributes/title')).to eq 'This is an interesting broadcast, find me' }
            specify { expect(response.body).to have_json_size(1).at_path('data') }
          end
        end

        describe 'query parameter blank' do
          let(:needle) { create(:broadcast, title: 'This is an interesting broadcast, find me') }
          let(:query) { '   ' }

          it 'is ignored' do
            expect(response.body).to have_json_size(6).at_path('data')
          end
        end

        describe 'query is the name of the TV channel' do
          let(:station) { create(:station, name: 'Arte') }
          let(:needle) { create(:broadcast, title: 'find me!', station: station) }
          let(:query) { 'Arte' }

          pending { expect(parse_json(response.body, 'data/0/attributes/title')).to eq 'find me!' }

          describe 'broadcast title vs. name of the TV channel' do
            let(:setup) do
              create(:broadcast, title: 'Station is matched but title is not', station: station)
              create(:broadcast, title: 'Arte Journal')
              haystack
            end

            pending 'both broadcasts are in the result set' do
              expect(response.body).to have_json_size(2).at_path('data')
            end

            pending 'title takes precedence over TV channel' do
              expect(parse_json(response.body, 'data/0/attributes/title')).to eq('Arte Journal')
              expect(parse_json(response.body, 'data/1/attributes/title')).to eq('Station is matched but title is not')
            end
          end
        end

        context 'query is the name of the showmaster' do
          let(:needle) { create(:broadcast, description: 'Awesome show, with Matthew as the showmaster') }
          let(:query) { 'Matthew' }

          pending { expect(parse_json(response.body, 'data/0/attributes/description')).to eq 'Awesome show, with Matthew as the showmaster' }
        end

        context 'query has typos' do
          let(:query) { 'Phlosophy' }
          let(:needle) { create(:broadcast, title: 'Philosophy') }

          pending { expect(parse_json(response.body, 'data/0/attributes/title')).to eq 'Philosophy' }
        end
      end
    end
  end
end
