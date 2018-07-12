class UserSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :gender, :birthday, :country_code,
             :state_code, :city, :postal_code, :locale, :email
end
