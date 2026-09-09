module Api
  module V1
    class PostableSerializer
      FAKE_ID = "fake".freeze

      # `ActiveModel::ArraySerializer` resolves a serializer from the unqualified class
      # name, so it looks for `PostSerializer` and misses `Api::V1::PostSerializer`.
      # Without this it silently falls back to `DefaultSerializer`, i.e. the raw
      # document. Controllers that `render json:` do not need it -- AMS's controller
      # integration supplies the namespace itself.
      SERIALIZER_NAMESPACE = "Api::V1".freeze

      attr_reader :postables, :tag_ids, :symptom_ids, :condition_ids, :treatment_ids, :postable_post_ids, :current_user

      def initialize(postables, current_user)
        @postables = postables
        @current_user = current_user
      end

      def as_json(_opts = {})
        posts = []
        comments = []

        postables.each { |postable| (postable.is_a?(Post) ? posts : comments) << postable }

        # The parent post of a comment is sideloaded for context even when the user did
        # not write it. It is appended after `prepare_ids` so it stays out of `post_ids`.
        parent_post_ids = comments.map(&:post_id) - posts.map(&:id)

        posts = with_associations(Post, posts.map(&:id))
        comments = with_associations(Comment, comments.map(&:id))

        prepare_ids(posts)

        posts.concat(with_associations(Post, parent_post_ids))

        {
          postables: [{
            id: FAKE_ID,
            post_ids: postable_post_ids,
            comment_ids: comments.map { |o| o.id.to_s }
          }],
          tags: serialize(Tag.where(id: tag_ids)),
          posts: serialize(posts, scope: current_user),
          comments: serialize(comments, scope: current_user),
          conditions: serialize(Condition.where(id: condition_ids)),
          symptoms: serialize(Symptom.where(id: symptom_ids)),
          treatments: serialize(Treatment.where(id: treatment_ids))
        }
      end

      private

      def serialize(collection, scope: nil)
        ActiveModel::ArraySerializer.new(collection, scope: scope, namespace: SERIALIZER_NAMESPACE)
      end

      # The controller queries `Postable`, which declares no associations, so eager
      # loading cannot happen there -- Mongoid rejects `Postable.includes(:notifications)`
      # outright. The serializers read notifications and reactions for every record, so
      # without this each one costs two extra queries. Re-fetching on the concrete class
      # is what makes eager loading possible; the ids are then put back in their original
      # order, since `post_ids` and `comment_ids` are ordered by the caller.
      def with_associations(model, ids)
        return [] if ids.empty?

        # PostSerializer also embeds comment ids; CommentSerializer has no equivalent.
        associations = [:notifications, :reactions]
        associations << :comments if model == Post

        by_id = model.where(:id.in => ids).includes(*associations).index_by(&:id)

        ids.filter_map { |id| by_id[id] }
      end

      def prepare_ids(posts)
        @tag_ids = []
        @symptom_ids = []
        @condition_ids = []
        @treatment_ids = []
        @postable_post_ids = []

        posts.each do |post|
          @postable_post_ids << post.id.to_s

          @tag_ids.concat(post.tag_ids)
          @symptom_ids.concat(post.symptom_ids)
          @condition_ids.concat(post.condition_ids)
          @treatment_ids.concat(post.treatment_ids)

          post.postable_id = FAKE_ID
        end
      end
    end
  end
end
