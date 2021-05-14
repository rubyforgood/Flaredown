[
  "test@flaredown.com"
].each do |email|
  FactoryBot.create(:user, email: email) unless User.exists?(email: email)
end
