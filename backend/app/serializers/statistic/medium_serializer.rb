module Statistic
  class MediumSerializer < ActiveModel::Serializer
    attributes :id, :name, :broadcasts_count, :total, :expected_amount
    type 'statistic/media'
  end
end
