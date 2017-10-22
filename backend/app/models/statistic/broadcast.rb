module Statistic
  class Broadcast < ApplicationRecord
    self.primary_key = :id
    paginates_per 10

    belongs_to :broadcast, class_name: '::Broadcast', foreign_key: :id

    def self.find_broadcast_as_of(broadcast, time)
      # TODO: fix
      broadcasts = Arel::Table.new(:broadcasts)
      view_definition.where(broadcasts[:id].eq(broadcast.id))
    end

    # Single Source of Truth
    # Use this view definition to generate the stored SQL
    def self.view_definition
      broadcasts = Arel::Table.new(:broadcasts)
      impressions = Arel::Table.new('"public"."impressions"')
      broadcasts.project(
        broadcasts[:id].as('id'),
        broadcasts[:title].as('title'),
        impressions[:id].count.as('impressions'),
        impressions[:response].average.as('approval'),
        impressions[:amount].average.as('average'),
        total_amount(impressions).as('total'),
        expected_amount(impressions).as('expected_amount')
      ).join(impressions, Arel::Nodes::OuterJoin)
                .on(impressions[:broadcast_id].eq(broadcasts[:id]))
                .group(broadcasts[:id], broadcasts[:title])
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
          global_average_per_impression
        ), 0]
      )
    end

    def self.global_average_per_impression
      Arel::Table.new('"public"."impressions"').project(
        Arel::Nodes::NamedFunction.new(
          'avg',
          [Arel::Nodes::NamedFunction.new(
            'coalesce',
            [Arel::Table.new('"public"."impressions"')[:amount], 0]
          )]
        )
      )
    end
    private

    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
