module Usernameable
  def user_name
    Profile.select(:screen_name).find_by!(user_id: SymmetricEncryption.decrypt(encrypted_user_id)).screen_name
  rescue SymmetricEncryption::CipherError
    ""
  end
end
