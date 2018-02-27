module Statistic
  class BroadcastHistory < ActiveModelSerializers::Model
    attributes :id, :timestamps, :statistics

    def id
      statistics.first.id
    end

    def title
      statistics.first.title
    end

    %i[impressions approval average total].each do |attribute|
      define_method attribute do
        self.statistics.map {|stat| stat.send(attribute) }
      end
    end
  end
end
