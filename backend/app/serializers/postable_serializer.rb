class PostableSerializer
  FAKE_ID = 'fake'.freeze

  attr_reader :postables, :tag_ids, :food_ids, :symptom_ids, :condition_ids, :treatment_ids, :postable_post_ids

  def initialize(postables)
    @postables = postables
  end

  def as_json(_opts = {})
    posts = []
    comments = []

    postables.each { |postable| (postable.is_a?(Post) ? posts : comments) << postable }

    prepare_ids(posts)

    posts.concat(Post.where(:id.in => comments.map(&:post_id) - posts.map(&:id)))

    {
      postables: [{
        id: FAKE_ID,
        post_ids: postable_post_ids,
        comment_ids: comments.map { |o| o.id.to_s }
      }],
      tags: ActiveModel::ArraySerializer.new(Tag.where(id: tag_ids), {}),
      foods: ActiveModel::ArraySerializer.new(Food.where(id: food_ids), {}),
      posts: ActiveModel::ArraySerializer.new(posts, {}),
      comments: ActiveModel::ArraySerializer.new(comments, {}),
      conditions: ActiveModel::ArraySerializer.new(Condition.where(id: condition_ids), {}),
      symptoms: ActiveModel::ArraySerializer.new(Symptom.where(id: symptom_ids), {}),
      treatments: ActiveModel::ArraySerializer.new(Treatment.where(id: treatment_ids), {})
    }
  end

  private

  def prepare_ids(posts)
    @tag_ids = []
    @food_ids = []
    @symptom_ids = []
    @condition_ids = []
    @treatment_ids = []
    @postable_post_ids = []

    posts.each do |post|
      @postable_post_ids << post.id.to_s

      @tag_ids.concat(post.tag_ids)
      @food_ids.concat(post.food_ids)
      @symptom_ids.concat(post.symptom_ids)
      @condition_ids.concat(post.condition_ids)
      @treatment_ids.concat(post.treatment_ids)

      post.postable_id = FAKE_ID
    end
  end
end
