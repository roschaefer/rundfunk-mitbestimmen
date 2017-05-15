module ChartData
  class DiffSerializer < ActiveModel::Serializer
    type 'chart-data/diffs'
    attributes :id, :series, :categories
  end
end
