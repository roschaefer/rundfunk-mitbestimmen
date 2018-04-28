module SimilarityGraph
  class NodeSerializer < ActiveModel::Serializer
    attributes :id, :title, :group

    def group
      object.medium_id
    end
  end
end
