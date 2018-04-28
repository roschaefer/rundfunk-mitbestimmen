module SimilarityGraph
  class GraphSerializer < ActiveModel::Serializer
    attributes :nodes, :links
    alias read_attribute_for_serialization send

    def nodes
      object.nodes.map do |node|
        SimilarityGraph::NodeSerializer.new(node).attributes
      end
    end

    def links
      object.links.map do |similarity|
        SimilarityGraph::LinkSerializer.new(similarity).attributes
      end
    end
  end
end
