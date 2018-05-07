class UserSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :gender, :age_group, :country_code,
             :state_code, :city, :postal_code, :locale, :email
end
