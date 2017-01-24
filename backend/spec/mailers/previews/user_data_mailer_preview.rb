# Preview all emails at http://localhost:3000/rails/mailers/user_data_mailer
class UserDataMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_data_mailer/trackings_csv
  def trackings_csv
    UserDataMailer.trackings_csv('some@email.yo', "header1,header2\nvalue1, value2\n")
  end

end
