class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, User, id: user.id
    can :manage, Profile, user_id: user.id

    can :read, Condition, global: true
    can :create, Condition, global: false
    can :manage, Condition, id: user.condition_ids
  end
end
