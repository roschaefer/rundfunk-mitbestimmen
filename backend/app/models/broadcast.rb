# frozen_string_literal: true

class Broadcast < ApplicationRecord
  include PgSearch
  has_paper_trail

  pg_search_scope :full_search,
                  against: { title: 'A', description: 'C' },
                  associated_against: { stations: { name: 'B' } },
                  using: {
                    tsearch: { any_word: true },
                    trigram: { threshold: 0.06 }
                  }

  has_many :impressions, dependent: :destroy

  before_validation :normalize_url, on: %i[create update]

  paginates_per 10
  belongs_to :topic, optional: true
  belongs_to :format, optional: true
  belongs_to :medium
  has_many :schedules
  has_many :stations, through: :schedules, dependent: :destroy # https://stackoverflow.com/a/30629704/2069431
  belongs_to :creator, class_name: 'User', optional: true
  has_one :statistic, class_name: 'Statistic::Broadcast', foreign_key: :id
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 30 }
  validates :medium, presence: true
  validates :mediathek_identification, uniqueness: { allow_nil: true }
  validate :description_should_not_contain_urls
  validate :image_url_should_contain_url
  validate :broadcast_url_should_contain_url

  scope :unevaluated, (->(user) { where.not(id: user.broadcasts.pluck(:id)) })
  scope :evaluated, (->(user) { where(id: user.broadcasts.pluck(:id)) })
  # TODO: Replace with SQL query, user.broadcasts.pluck(:id) might become large

  scope :aliased_inner_join, (lambda do |the_alias, joined_model|
    join_table_alias = joined_model.arel_table.alias(the_alias) # specify a predictable join table alias
    # now create the arel INNER JOIN manually
    aliased_join = join_table_alias.create_on(Broadcast.arel_table[:id].eq(join_table_alias[:broadcast_id]))
    Broadcast.joins(Broadcast.arel_table.create_join(join_table_alias, aliased_join, Arel::Nodes::InnerJoin))
  end)

  scope :where_station, (->(station) { aliased_inner_join(:schedule_table_alias, Schedule).where('schedule_table_alias.station_id' => station) })

  before_validation do
    if title
      self.title = title.gsub(/\s+/, ' ')
      self.title = title.strip
    end
  end

  after_commit do
    Scenic.database.refresh_materialized_view(:statistic_broadcasts, concurrently: true, cascade: false)
  end

  def self.search(query: nil, filter_params: nil, sort: nil, seed: nil, user: nil)
    results = Broadcast.all
    results = results.full_search(query) unless query.blank?
    if filter_params
      results = results.where(medium: filter_params[:medium]) unless filter_params[:medium].blank?
      results = results.where_station(filter_params[:station]) unless filter_params[:station].blank?
      results = results.review_filter(filter_params[:review], user) unless filter_params[:review].blank? || user.nil?
    end
    results = results.results_order(sort, seed: seed) if %w[asc desc random].include?(sort)

    results
  end

  def self.review_filter(review_status, user)
    if review_status == 'reviewed'
      evaluated(user)
    elsif review_status == 'unreviewed'
      unevaluated(user)
    end
  end

  def self.results_order(sort, seed: nil)
    if %w[asc desc].include?(sort)
      reorder(title: sort)
    elsif sort == 'random'
      if seed
        clamp_seed = [seed.to_f, -1, 1].sort[1] # seed is in [-1, 1]
        query = Broadcast.send(:sanitize_sql, ['select setseed( ? )', clamp_seed])
        Broadcast.connection.execute(query)
      end
      order('RANDOM()')
    end
  end

  private

  def normalize_url
    self.broadcast_url = nil if broadcast_url.blank?
    self.image_url = nil if image_url.blank?
  end

  def description_should_not_contain_urls
    return unless description
    return unless description.match?(URI.regexp(%w[http https]))

    errors.add(:description, :no_urls)
  end

  def image_url_should_contain_url
    return unless image_url
    return if image_url.match?(URI.regexp(%w[http https]))

    errors.add(:image_url, :invalid_url)
  end

  def broadcast_url_should_contain_url
    return unless broadcast_url
    return if broadcast_url.match?(URI.regexp(%w[http https]))

    errors.add(:broadcast_url, :invalid_url)
  end
end
