class PatternCreator
  attr_accessor :name, :includes, :user, :start_at, :end_at

  def initialize(options)
    @name = options[:name]
    @start_at, @end_at = options[:start_at], options[:end_at]

    @includes = options[:includes]
    @user = User.find_by(id: options[:user_id])
  end

  def create
      Pattern.create(
        name: name,
        includes: includes,
        encrypted_user_id: encrypted_user_id
      )
  end

  private

    def encrypted_user_id
      SymmetricEncryption.encrypt(user.id)
    end
end
