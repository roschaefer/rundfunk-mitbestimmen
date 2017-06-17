class User < ActiveRecord::Base
  enum role: { guest: -1, contributor: 0, broadcaster: 1, admin: 2 }

  has_many :selections
  has_many :liked_broadcasts, -> { where(selections: { response: 1 }) }, source: :broadcast, through: :selections
  has_many :broadcasts, through: :selections

  before_validation do
    # allow bad emails but don't sent out mails
    self.has_bad_email ||= ValidEmail2::Address.new(email).disposable?
  end
  validates :email, uniqueness: true, if: proc { |u| u.email.present? }
  validates :auth0_uid, uniqueness: true, if: proc { |u| u.auth0_uid.present? }

  def self.from_token_payload(payload)
    if payload['sub'].blank?
      nil
    else

      if payload['email'].present?
        legacy_user = find_by(email: payload['email'])
        if legacy_user
          legacy_user.auth0_uid = payload['sub']
          legacy_user.save if legacy_user.changed?
          return legacy_user
        end
      end

      find_or_create_by(auth0_uid: payload['sub'], email: payload['email'])
    end
  end

  def location?
    latitude.present? && longitude.present?
  end

  def update_location(location)
    return unless location
    self.latitude = location.latitude
    self.longitude = location.longitude
    save
  end
end
