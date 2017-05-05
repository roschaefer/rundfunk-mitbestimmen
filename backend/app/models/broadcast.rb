class Broadcast < ApplicationRecord
  include PgSearch

  pg_search_scope :search_by_title, against: :title

  has_many :selections, dependent: :destroy

  paginates_per 10
  belongs_to :topic
  belongs_to :format
  belongs_to :medium
  belongs_to :station, counter_cache: true
  belongs_to :creator, class_name: User
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { minimum: 30 }
  validates :medium, presence: true
  validates :mediathek_identification, uniqueness: { allow_nil: true }
  validate :description_should_not_contain_urls

  scope :unevaluated, ->(user) { where.not(id: user.broadcasts.pluck(:id)) }
  # TODO: Replace with SQL query, user.broadcasts.pluck(:id) might become large

  before_validation do
    if title
      self.title = title.gsub(/\s+/, ' ')
      self.title = title.strip
    end
  end

  private

  def description_should_not_contain_urls
    return unless description =~ URI.regexp(%w(http https))
    errors.add(:description, :no_urls)
  end
end
