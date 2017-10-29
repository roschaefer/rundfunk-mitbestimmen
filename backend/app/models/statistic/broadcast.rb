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

    def self.kpis_at(time)
      historical_kpis(time)
    end

    def self.kpis_for_broadcast_at(broadcast, time)
      historical_kpis(time).where(Arel.sql("id = #{broadcast.id}"))
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

    def self.historical_kpis(time)
      # 1 row for each broadcast
      table = Arel::SelectManager.new(Arel.sql("(#{broadcast_statistics_table.to_sql}) as results"))
      # Add average selection per impression column
      table = table.join(average_amount_per_selection_table, Arel::Nodes::OuterJoin).on(Arel.sql("true"))
      # Add with block with temporal filtered impressions
      table = table.with(with_temporal_impressions(time))
      # Project final kpi values to expose
      table = table.project(
        "id",
        "title",
        "impressions",
        "(CAST(positives AS FLOAT)/CAST(NULLIF(impressions,0)   AS FLOAT))         AS approval",
        "COALESCE((CAST(total     AS FLOAT)/CAST(NULLIF(positives,0) AS FLOAT)),0) AS average",
        "total",
        "impressions * average_amount_per_selection as expected_amount"
      )
      # Add table entries for broadcasts without impressions
      table = table.union(default_values_for_broadcasts_without_impressions)

      # Expose SelectManager object
      final = Arel::SelectManager.new(Arel.sql("#{table.to_sql} as kpis"))
      final.project(Arel.star)
    end

    def self.default_values_for_broadcasts_without_impressions
      impressions = Arel::Table.new(:impressions)
      broadcasts_without_impressions = Arel::Table.new(:broadcasts)

      broadcasts_without_impressions.
          join(impressions, Arel::Nodes::OuterJoin).on(broadcasts_without_impressions[:id].eq(impressions[:broadcast_id])).
          where(impressions[:broadcast_id].eq(nil)).
          project(
              broadcasts_without_impressions[:id].as("id"),
              broadcasts_without_impressions[:title].as("title"),
              "0 AS impressions",
              "NULL AS approval",
              "NULL AS average",
              "0 AS total",
              "0 AS expected_amount"
          )
    end

    def self.broadcast_statistics_table
      broadcasts = Arel::Table.new(:broadcasts)
      impressions = Arel::Table.new(:impressions)

      broadcasts.
        join(impressions).on(broadcasts[:id].eq(impressions[:broadcast_id])).
        group(impressions[:broadcast_id], broadcasts[:title]).
        project(
            impressions[:broadcast_id].as("id"), 
            broadcasts[:title].as("title"),
            impressions[:id].count.as("impressions"),
            "COALESCE(SUM(CASE WHEN impressions.response = 1 THEN 1 ELSE 0 END), 0) AS positives",
            "COALESCE(SUM(amount),0) AS total"
        )
    end

    def self.average_amount_per_selection_table
      all_impressions = Arel::Table.new(:impressions)

      all_impressions.
        project("SUM(amount) / COUNT(*) AS average_amount_per_selection").
        as("general")
    end

    def self.with_temporal_impressions(time)
      temporal_impressions = Arel::Table.new(:impressions)

      Arel::Nodes::As.new(temporal_impressions, Arel.sql("(#{Impression.as_of(time).to_sql})"))
    end

    # this isn't strictly necessary, but it will prevent
    # rails from calling save, which would fail anyway.
    def readonly?
      true
    end
  end
end
