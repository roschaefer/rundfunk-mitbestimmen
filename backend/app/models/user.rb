class User < ActiveRecord::Base
  enum role: { guest: -1, contributor: 0, broadcaster: 1, admin: 2 }

  has_many :impressions
  has_many :liked_broadcasts, -> { where(impressions: { response: 1 }) }, source: :broadcast, through: :impressions
  has_many :broadcasts, through: :impressions

  before_validation do
    # allow bad emails but don't sent out mails
    self.has_bad_email ||= ValidEmail2::Address.new(email).disposable?
  end

  after_save :geocode_last_ip

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

  def geocode_last_ip
    GeocodeUserJob.perform_later(auth0_uid) unless location?
  rescue Redis::CannotConnectError
    # ignore
  end

  def update_location(geocoder_result) # This method is used by a geocode_user_job YA ESTABA
    return unless geocoder_result
    self.latitude = geocoder_result.latitude
    self.longitude = geocoder_result.longitude
    self.country_code = geocoder_result.country_code
    self.state_code = geocoder_result.state_code
    self.postal_code = geocoder_result.postal_code
    self.city = geocoder_result.city
    save
  end

  def update_location_data(latitude, longitude)
    geocoder_result = Geocoder.search("#{latitude},#{longitude}").first
    update_location(geocoder_result)
  end

  def update_locale(locale)
    return unless locale
    self.locale = locale
    save
  end
end
