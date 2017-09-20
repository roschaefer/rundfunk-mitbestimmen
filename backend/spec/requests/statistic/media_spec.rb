require 'rails_helper'

RSpec.describe 'Statistic::Medium', type: :request do
  describe 'GET' do
    let(:params) { {} }
    let(:request) { get url, params: params }

    context 'given some data' do
      before(:all) do
        media = [
          create(:medium, id: 1, name_de: 'TV', name_en: 'TV'),
          create(:medium, id: 2, name_de: 'Radio', name_en: 'Radio'),
          create(:medium, id: 3, name_de: 'Online', name_en: 'Online')
        ]
        broadcasts = []
        media.each_with_index do |medium, i|
          broadcasts += create_list(:broadcast, (i + 1), medium: medium)
        end
        broadcasts.each_with_index do |broadcast, i|
          create_list(:impression, (i + 1), broadcast: broadcast, response: :neutral)
          create_list(:impression, (i + 2), broadcast: broadcast, response: :positive, amount: (i * 2 + 1))
        end
        random_medium = create(:medium, name_de: 'Wasauchimmer', name_en: 'Whatever')
        create(:impression, broadcast: create(:broadcast, medium: random_medium), response: :positive, amount: 1.0)
        create(:impression, broadcast: create(:broadcast, medium: random_medium), response: :neutral)
      end

      after(:all) do
        Impression.destroy_all
        User.destroy_all
        Broadcast.destroy_all
        Medium.destroy_all
        Station.destroy_all
      end

      describe '/statistic/media/:id' do
        let(:url) { '/statistic/media/2' }
        describe 'response' do
          before { request }

          describe '/data/:id/attributes/' do
            subject { parse_json(response.body, "data/attributes/#{attribute}") }

            describe 'name' do
              let(:attribute) { 'name' }
              it { is_expected.to eq('Radio') }
            end

            describe 'broadcasts_count' do
              let(:attribute) { 'broadcasts-count' }
              it { is_expected.to eq(2) }
            end

            describe 'total' do
              let(:attribute) { 'total' }
              it { is_expected.to eq('29.0') }
            end

            describe 'expected_amount' do
              let(:attribute) { 'expected-amount' }
              it { is_expected.to eq('47.52') }
            end
          end
        end
      end

      describe '/statistic/media/' do
        let(:url) { '/statistic/media/' }

        describe 'response' do
          before { request }

          describe '/data/:id/attributes/' do
            subject { [0, 1, 2, 3].collect { |i| parse_json(response.body, "data/#{i}/attributes/#{attribute}") } }

            describe 'name' do
              let(:attribute) { 'name' }
              it { is_expected.to eq(%w[Online Radio TV Wasauchimmer]) }
            end

            describe 'broadcasts_count' do
              let(:attribute) { 'broadcasts-count' }
              it { is_expected.to eq([3, 2, 1, 2]) }
            end

            describe 'total' do
              let(:attribute) { 'total' }
              it { is_expected.to eq(%w[166.0 29.0 2.0 1.0]) }
            end

            describe 'expected_amount' do
              let(:attribute) { 'expected-amount' }
              it { is_expected.to eq(%w[130.68 47.52 11.88 7.92]) }
            end
          end
        end
      end
    end
  end
end
