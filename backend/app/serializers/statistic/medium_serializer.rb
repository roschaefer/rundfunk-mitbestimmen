module Statistic
  class MediumSerializer < ActiveModel::Serializer
    attributes :id, :name, :broadcasts_count, :total, :expected_amount
  end
end
