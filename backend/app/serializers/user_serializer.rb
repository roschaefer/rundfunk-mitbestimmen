class UserSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :country_code, :state_code, :city, :postal_code, :locale
end
