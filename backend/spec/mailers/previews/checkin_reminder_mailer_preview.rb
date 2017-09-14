class CheckinReminderMailerPreview < ActionMailer::Preview
  # Preview emails at http://localhost:3000/rails/mailers/checkin_reminder_mailer/remind
  def remind
    CheckinReminderMailer.remind(email: 'example@ex.com')
  end
end
