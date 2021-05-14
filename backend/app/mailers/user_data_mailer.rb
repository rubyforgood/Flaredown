class UserDataMailer < ApplicationMailer
  def trackings_csv(email, csv_data)
    attachments["data.csv"] = csv_data

    mail to: email
  end
end
