class Impression < ApplicationRecord
  BUDGET = 17.5
  enum response: { neutral: 0, positive: 1 }
  belongs_to :user
  belongs_to :broadcast

  validates :user, presence: true
  validates :broadcast, presence: true
  validates :broadcast_id, uniqueness: { scope: :user_id }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :amount, absence: true, unless: proc { |s| s.positive? }
  validate :total_amount_does_not_exceed_budget

  after_commit do
    Scenic.database.refresh_materialized_view(:statistic_broadcasts, concurrently: true, cascade: false)
  end

  private

  def total_amount_does_not_exceed_budget
    return unless amount
    current_sum = amount + Impression.where(user: user).where.not(id: id).sum(:amount)
    return if current_sum <= BUDGET
    errors.add(:amount, I18n.t('activerecord.errors.models.impression.attributes.amount.total', sum: ActionController::Base.helpers.number_to_currency(current_sum, unit: '€'), budget: ActionController::Base.helpers.number_to_currency(BUDGET, unit: '€')))
  end
end
