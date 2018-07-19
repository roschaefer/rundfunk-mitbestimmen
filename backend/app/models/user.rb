class User < ActiveRecord::Base
  enum role: { contributor: 0, broadcaster: 1, admin: 2 }
  enum gender: %i[male female other]

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

  # This method is used by a geocode_user_job YA ESTABA
  def assign_location_attributes(geocoder_result)
    return unless geocoder_result
    self.latitude = geocoder_result.latitude
    self.longitude = geocoder_result.longitude
    self.country_code = geocoder_result.country_code
    self.state_code = geocoder_result.state_code
    self.postal_code = geocoder_result.postal_code
    self.city = geocoder_result.city
  end

  def update_and_reverse_geocode(params)
    assign_attributes(params)
    if will_save_change_to_latitude? || will_save_change_to_longitude?
      geocoder_result = Geocoder.search("#{latitude},#{longitude}").first
      assign_location_attributes(geocoder_result)
    end
    save
  end

  def reasons_for_notifications
    reasons = []
    broadcasts_created_since_last_login = Broadcast.where('created_at >= ?', last_login)
    if broadcasts_created_since_last_login.count >= 5
      reasons << :recently_created_broadcasts
    end
    reasons
  end


end
