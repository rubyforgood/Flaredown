namespace :trackables do
  desc 'flaredown | merge trackables'

  TRACKABLE_TYPES = %w(condition symptom treatment).freeze

  task merge: :environment do
    TRACKABLE_TYPES.map { |trackable_type| merge_trackables(trackable_type) }
  end

  def select_duplicates(trackable_type)
    trackable_class = trackable_type.capitalize.constantize

    trackable_class.find_each do |obj|
      same_translations = trackable_class::Translation.where("name ~* ?", obj.name.split(' ').join('\\s+'))
      next if same_translations.length == 0

      same_trackables = trackable_class.where(id: same_translations.select("#{trackable_type}_id".to_sym)).order(trackable_usages_count: :desc)

      merge_trackables(trackable_type, same_trackables)
    end
  end

  def merge_trackables(trackable_type, same_trackables)
    parent, *rest = same_trackables
    rest_ids = rest.map(&:id)

    merge_user_trackable_association(trackable_type, parent, rest) # UserCondition
    merge_trackable_usages(parent, rest)
    merge_trackings(parent, rest)
    merge_topic_following(parent, rest_ids)
    merge_checkin_trackables(trackable_type, parent, rest_ids)
    merge_post_trackables(trackable_type, parent, rest_ids)

    rest.map { |trackable| trackable.destroy }
  end

  def merge_user_trackable_association(trackable_type, parent, rest)
    klass = "User#{trackable_type.capitalize}".constantize

    klass.where(trackable_type.to_sym => rest).map do |user_trackable_type|
      parent_user_trackable = klass.find_by(trackable_type.to_sym => parent, user_id: user_trackable_type.user_id)

      parent_user_trackable.present? ? user_trackable_type.destroy : user_trackable_type.update_columns("#{trackable_type}_id".to_sym => parent.id)
    end
  end

  def merge_trackable_usages(parent, rest)
    TrackableUsage.where(trackable: rest).map do |tr_usage|
      begin
        tr_usage.update_attributes(trackable_id: parent.id)

      rescue ActiveRecord::RecordNotUnique
        parent_usage.count += tr_usage.count
        parent_usage.save

        tr_usage.destroy
      end

      parent.increment!(:trackable_usages_count)
    end
  end

  def merge_trackings(parent, rest)
    Tracking.where(trackable: rest).map do |tracking|
      tracking.update_attributes(trackable_id: parent.id)
    end
  end

  def merge_topic_following(trackable_type, parent, rest_ids)
    trackable_key = "#{trackable_type}_ids"

    TopicFollowing.all(trackable_key.to_sym.in => rest_ids).map do |tf|
      updated_ids = tf.send(trackable_key) - rest_ids + [parent.id]

      tf.update_attributes(trackable_key.to_sym => updated_ids.uniq)
    end
  end

  def merge_checkin_trackables(trackable_type, parent, rest_ids)
    klass = "Checkin::#{trackable_type.capitalize}".constantize

    klass.where("#{trackable_type}_id".to_sym.in => rest_ids).map do |checkin|
      checkin.update_attributes("#{trackable_type}_id".to_sym => parent.id)
    end
  end

  def merge_post_trackables(trackable_type, parent, rest_ids)
    trackable_key = "#{trackable_type}_ids"

    Post.where(trackable_key.to_sym.in => rest_ids).map do |post|
      updated_ids = post.send(trackable_key) - rest_ids + [parent.id]

      post.update_attributes(trackable_key.to_sym => updated_ids.uniq)
    end
  end
end
