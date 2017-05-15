module ChartData
  class Diff < ActiveModelSerializers::Model
    attributes :series, :categories

    def id
      0
    end
  end
end
