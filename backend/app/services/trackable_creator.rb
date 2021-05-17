class TrackableCreator
  # Assumes trackable initialized by CanCanCan
  def initialize(trackable, user)
    @trackable = trackable
    @user = user
  end

  def create!
    searchable_attr = @trackable.instance_of?(Food) ? "long_desc" : "name"
    same_trackable = @trackable
      .class
      .with_translations(I18n.locale)
      .where("#{searchable_attr} ILIKE :name", name: @trackable.name)
      .first

    @trackable = same_trackable if same_trackable.present?
    unless @trackable.global? || user_trackable_exists?
      user_trackable_class.create!(
        :user => @user, trackable_attr.to_sym => @trackable
      )
      @trackable.reload
    end
    @trackable
  end

  private

  def user_trackable_class
    "User#{@trackable.class.name}".constantize
  end

  def trackable_attr
    @trackable.class.name.underscore
  end

  def user_trackable_exists?
    return false if @trackable.id.nil?
    user_trackable_class.find_by(
      :user_id => @user.id, "#{trackable_attr}_id".to_sym => @trackable.id
    ).present?
  end
end
