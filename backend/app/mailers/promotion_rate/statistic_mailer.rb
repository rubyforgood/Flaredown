class PromotionRate::StatisticMailer < ApplicationMailer
  layout 'mailer_layout'

  def show(objects, start_date, end_date)
    @objects = objects
    @start_date = start_date
    @end_date = end_date

    mail(to: 'test@flaredown.com', subject: I18n.t('promotion_rate.statistic.subject'))
  end
end
