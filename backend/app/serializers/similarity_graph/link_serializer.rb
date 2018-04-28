module SimilarityGraph
  class LinkSerializer < ActiveModel::Serializer
    attributes :source, :target, :value

    def source
      object.broadcast1_id
    end

    def target
      object.broadcast2_id
    end
  end
end
