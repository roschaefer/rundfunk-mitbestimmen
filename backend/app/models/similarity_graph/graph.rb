module SimilarityGraph
  class Graph
    include ActiveModel::Model
    include ActiveModel::Serialization
    attr_accessor :links, :nodes

    def initialize(attributes)
      @links = attributes[:links]
      @nodes = attributes[:nodes]
    end
  end
end
