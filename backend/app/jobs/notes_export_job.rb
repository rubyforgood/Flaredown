class NotesExportJob < ActiveJob::Base
  SUBFIELD_SEPARATOR = "; ".freeze

  queue_as :default

  attr_accessor :user_locale, :symptom_ids, :condition_ids, :treatment_ids, :tag_ids, :food_ids

  def perform(user_id)
    user = User.find(user_id)
    note_details = user.checkins.where.not(note: ["", nil]).order(date: :desc).pluck(:date, :note)
    body = note_details.map { |detail| detail.join(",") }

    ActionMailer::Base.mail(
      from: Rails.application.secrets.smtp_email_from,
      to: user.email,
      subject: "Flaredown data export",
      body: body
    ).deliver
  end
end
