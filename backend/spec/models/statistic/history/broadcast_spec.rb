require 'rails_helper'

RSpec.describe Statistic::Broadcast, type: :model do

  before(:all) do
    clean_database!
  end

  after(:all) do
    clean_database!
  end

  describe 'history of a broadcast' do

    without_transactional_fixtures do
      before(:all) do
        broadcast = create(:broadcast)
        @t1 = Time.now
        create(:impression, broadcast: broadcast, response: :positive, amount: 3.0)
        @t2 = Time.now
        create(:impression, broadcast: broadcast, response: :positive, amount: 5.0)
        @t3 = Time.now
        create(:impression, broadcast: broadcast, response: :positive, amount: 7.0)
        @t4 = Time.now
      end


      let(:view_definition) do
        <<~SQL
        SELECT
          id, title, impressions,
          (CAST(positives AS FLOAT)/CAST(NULLIF(impressions,0)   AS FLOAT))         AS approval,
          COALESCE((CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)),0) AS average,
          total,
          impressions * average_amount_per_selection as expected_amount
        FROM (
          SELECT
          broadcast_id                                                           AS id,
          broadcasts.title                                                       AS title,
          COUNT(*)                                                               AS impressions,
          COALESCE(SUM(CASE WHEN impressions.response = 1 THEN 1 ELSE 0 END), 0) AS positives,
          COALESCE(SUM(amount),0)                                                AS total
          FROM impressions
          JOIN broadcasts ON impressions.broadcast_id = broadcasts.id
          GROUP BY impressions.broadcast_id, broadcasts.title
        ) t LEFT JOIN (
          SELECT SUM(amount)/COUNT(*) AS average_amount_per_selection FROM impressions
        ) a ON true
        UNION ALL
        SELECT broadcasts.id AS id, broadcasts.title AS title, 0 AS impressions, NULL AS approval, NULL AS average, 0 AS total, 0 AS expected_amount
        FROM broadcasts
        LEFT JOIN impressions ON broadcasts.id = impressions.broadcast_id
        WHERE impressions.broadcast_id IS NULL;
        SQL
      end

      let(:sql) { "WITH IMPRESSIONS AS ( #{ Impression.as_of(time).to_sql } ) #{view_definition}" }

      describe '#total' do
        subject { described_class.find_by_sql(sql).first.total }

        describe 't1' do
          let(:time) { @t1 }
          it { is_expected.to eq(0.0) }
        end

        describe 't2' do
          let(:time) { @t2 }
          it { is_expected.to eq(3.0) }
        end

        describe 't3' do
          let(:time) { @t3 }
          it { is_expected.to eq(8.0) }
        end

        describe 't4' do
          let(:time) { @t4 }
          it { is_expected.to eq(15.0) }
        end
      end
    end
  end
end
