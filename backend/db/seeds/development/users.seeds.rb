[
  'test@flaredown.com'
].each do |email|
  FactoryGirl.create(:user, email: email) unless User.exists?(email: email)
end
