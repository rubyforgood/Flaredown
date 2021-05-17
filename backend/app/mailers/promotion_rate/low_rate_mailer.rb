class PromotionRate::LowRateMailer < ApplicationMailer
  layout "mailer_layout"

  def show(email, objects, start_date, end_date)
    @email = email
    @objects = objects
    @start_date = start_date
    @end_date = end_date

    mail(to: @email, subject: I18n.t("promotion_rate.low_rate.subject"))
  end
end
