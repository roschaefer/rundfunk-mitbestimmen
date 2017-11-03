module Statistic
  class Broadcast < ApplicationRecord
    self.primary_key = :id
    paginates_per 10

    belongs_to :broadcast, class_name: '::Broadcast', foreign_key: :id

    def self.find_broadcast_as_of(broadcast, time)
      find_by_sql(broadcast_as_of(broadcast, time).to_sql).first
    end

    def self.broadcast_as_of(broadcast, time)
      broadcasts ||= Arel::Table.new(:broadcasts)
      as_of(time).where(broadcasts[:id].eq(broadcast.id))
    end

    def self.as_of(time, broadcasts: nil)
      broadcasts ||= Arel::Table.new(:broadcasts)
      impressions  = Arel::Table.new(:historical_impressions)
      composed_cte = Arel::Nodes::As.new(
        impressions,
        Arel::Nodes::Grouping.new(
          Arel::Nodes::SqlLiteral.new(Impression::History.at(time).to_sql)
        )
      )
      view_definition(
        impressions: impressions,
        broadcasts: broadcasts
      ).with(composed_cte)
    end

    # Single Source of Truth
    # Use this view definition to generate the stored SQL
    def self.view_definition(broadcasts: nil, impressions: nil)
      broadcasts ||= Arel::Table.new(:broadcasts)
      impressions ||= Arel::Table.new('"public"."impressions"')

      broadcasts.project(
        broadcasts[:id],
        broadcasts[:title],
        impressions[:id].count.as('impressions'),
        impressions[:response].average.as('approval'),
        impressions[:amount].average.as('average'),
        total_amount(impressions).as('total'),
        expected_amount(impressions).as('expected_amount')
      ).join(impressions, Arel::Nodes::OuterJoin).on(
        impressions[:broadcast_id].eq(broadcasts[:id])
      ).group(broadcasts[:id], broadcasts[:title])
    end

    def self.total_amount(impressions_table)
      Arel::Nodes::NamedFunction.new(
        'coalesce',
        [impressions_table[:amount].sum, 0]
      )
    end

    def self.expected_amount(impressions_table)
      Arel::Nodes::NamedFunction.new(
        'coalesce',
        [Arel::Nodes::Multiplication.new(
          impressions_table[:id].count,
          global_average_per_impression(impressions_table)
        ), 0]
      )
    end

    def self.global_average_per_impression(impressions_table)
      impressions_table.project(
        Arel::Nodes::NamedFunction.new(
          'avg',
          [Arel::Nodes::NamedFunction.new(
            'coalesce',
            [impressions_table[:amount], 0]
          )]
        )
      )
    end

    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
