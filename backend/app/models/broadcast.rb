class Broadcast < ApplicationRecord
  include PgSearch
  has_paper_trail

  pg_search_scope :search_by_title, against: :title

  has_many :impressions, dependent: :destroy

  paginates_per 10
  belongs_to :topic, optional: true
  belongs_to :format, optional: true
  belongs_to :medium
  has_many :schedules
  has_many :stations, through: :schedules
  belongs_to :creator, class_name: 'User', optional: true
  has_one :statistic, class_name: 'Statistic::Broadcast', foreign_key: :id
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 30 }
  validates :medium, presence: true
  validates :mediathek_identification, uniqueness: { allow_nil: true }
  validate :description_should_not_contain_urls

  scope :unevaluated, (->(user) { where.not(id: user.broadcasts.pluck(:id)) })
  # TODO: Replace with SQL query, user.broadcasts.pluck(:id) might become large

  before_validation do
    if title
      self.title = title.gsub(/\s+/, ' ')
      self.title = title.strip
    end
  end

  private

  def description_should_not_contain_urls
    return unless description =~ URI.regexp(%w[http https])
    errors.add(:description, :no_urls)
  end
end
