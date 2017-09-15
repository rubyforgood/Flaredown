class CheckinReminderMailerPreview < ActionMailer::Preview
  # Preview emails at http://localhost:3000/rails/mailers/checkin_reminder_mailer/remind
  def remind
    CheckinReminderMailer.remind(email: 'test@flaredown.com')
  end
end
