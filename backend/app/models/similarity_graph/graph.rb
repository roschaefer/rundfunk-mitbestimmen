module SimilarityGraph
  class Graph
    attr_accessor :links, :nodes

    def initialize(attributes)
      @links = attributes[:links]
      @nodes = attributes[:nodes]
    end
  end
end
