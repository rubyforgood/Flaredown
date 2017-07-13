class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, User, id: user.id
    can :manage, Profile, user_id: user.id

    can :show, Condition
    can :read, Condition, id: popular_trackable_ids('Condition')
    can :index, Condition, global: true
    cannot :index, Condition, global: false
    can :index, Condition, global: false, id: user.topic_following.condition_ids
    can :create, Condition, global: false
    can :manage, Condition, id: user.condition_ids

    can :read, Food
    can :create, Food

    can :read, HarveyBradshawIndex, encrypted_user_id: user.encrypted_id

    can :create, HarveyBradshawIndex do |hbi|
      checkin = hbi.checkin

      checkin.encrypted_user_id == user.encrypted_id && checkin.available_for_hbi?
    end

    can :read, [Comment, Post]
    can :create, [Comment, Post], encrypted_user_id: user.encrypted_id

    can :read, Notification
    can :destroy, Notification, encrypted_notify_user_id: user.encrypted_id
    can :update, Notification, encrypted_notify_user_id: user.encrypted_id

    can :read, Postable, encrypted_user_id: user.encrypted_id

    can :read, Reaction
    can [:create, :update, :destroy], Reaction, encrypted_user_id: user.encrypted_id

    can :show, Symptom
    can :read, Symptom, id: popular_trackable_ids('Symptom')
    can :index, Symptom, global: true
    cannot :index, Symptom, global: false
    can :index, Symptom, global: false, id: user.topic_following.symptom_ids
    can :create, Symptom, global: false
    can :manage, Symptom, id: user.symptom_ids

    can [:read, :update], TopicFollowing, encrypted_user_id: user.encrypted_id

    can :show, Treatment
    can :read, Treatment, id: popular_trackable_ids('Treatment')
    can :index, Treatment, global: true
    cannot :index, Treatment, global: false
    can :index, Treatment, global: false, id: user.topic_following.treatment_ids
    can :create, Treatment, global: false
    can :manage, Treatment, id: user.treatment_ids

    can :manage, Tracking, user_id: user.id

    can :manage, Tag

    can :read, Weather if user.persisted?
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def popular_trackable_ids(trackable_class_name)
    user_trackable_class = "User#{trackable_class_name}".constantize
    trackable_id_attr = "#{trackable_class_name.underscore}_id".to_sym
    association_global_ids = trackable_class_name.to_s.constantize.where(global: true).ids

    counts =
      user_trackable_class
        .group(trackable_id_attr)
        .having(trackable_id_attr => association_global_ids)
        .count

    min_popularity = Flaredown.config.trackables_min_popularity
    counts.select { |_id, count| count >= min_popularity }.keys
  end
end
