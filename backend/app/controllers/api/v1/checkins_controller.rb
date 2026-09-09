module Api
  module V1
    class CheckinsController < ApplicationController
      def index
        date = params[:date]

        if date.blank? && params.require(:page)
          render json: current_user.checkins.where(:note.nin => [nil, ""]).order_by(date: :desc).page(params[:page]).per(10)
        else
          day = Date.parse(date)
          checkins = current_user.checkins.by_date(day.beginning_of_day, day.end_of_day)
          # to_a so the criteria is loaded and eager loaded once, not once per serializer pass
          render json: checkins.includes([:harvey_bradshaw_index, :promotion_rate, :conditions, :symptoms, :treatments]).to_a
        end
      end

      def show
        render json: Checkin.find(id)
      end

      def create
        date = params.require(:checkin).require(:date)
        parsed = DateTime.parse(date)
        now = DateTime.current
        save_date = DateTime.new(parsed.year, parsed.month, parsed.day, now.hour, now.minute, now.second)
        checkin = Checkin::Creator.new(current_user.id, save_date).create!
        render json: checkin
      end

      def update
        render json: Checkin::Updater.new(current_user, params).update!
      end

      private

      def id
        params.require(:id)
      end
    end
  end
end
