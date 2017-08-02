module ChartData
  class Diff < ActiveModelSerializers::Model
    attributes :id, :series, :categories
  end
end
