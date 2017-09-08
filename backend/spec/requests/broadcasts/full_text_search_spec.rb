require 'rails_helper'

RSpec.describe "Broadcasts::Searches", type: :request do
  describe "GET /broadcasts" do
    let(:url) { '/broadcasts' }
    let(:action) { get url, params: params, headers: headers }
    let(:params) { { q: query } }
    let(:js) { JSON.parse(response.body) }

    subject do
      action
      js
    end

    context 'given a broadcast' do
      describe '?q=' do
        let(:query) { 'find me' }

        before { create(:broadcast, title: 'This is an interesting broadcast, find me') }

        it 'returns only relevant broadcasts' do
          expect(subject['data'].length).to eq(1)
          found_title = js['data'][0]['attributes']['title']
          expect(found_title).to eq 'This is an interesting broadcast, find me'
        end

        describe 'query parameter empty' do
          let(:params) { { q: '' } }
          it 'is ignored' do
            expect(subject['data'].length).to eq(1)
          end
        end
      end

      context 'query is the name of the TV channel' do
        let(:station) { create(:station, name: 'Arte')}
        let(:broadcast) { create(:broadcast, station: station)}
        before { broadcast }

        let(:query) { 'Arte' }
        it 'is found' do
          expect(subject['data'].length).to eq(1)
        end
      end

      context 'query is the name of the showmaster' do
        let(:broadcast) { create(:broadcast, description: 'Awesome show, with Matthew as the showmaster')}
        before { broadcast }

        let(:query) { 'Matthew' }
        it 'is found' do
          expect(subject['data'].length).to eq(1)
        end
      end

      context 'query has typos' do
        let(:query) { 'Phlosophy' }
        let(:broadcast) { create(:broadcast, title: 'Philosophy')}
        before { broadcast }

        it 'is found' do
          expect(subject['data'].length).to eq(1)
        end
      end
    end
  end
end
