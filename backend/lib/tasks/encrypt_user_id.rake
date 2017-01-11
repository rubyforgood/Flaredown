namespace :app do
  desc 'flaredown | encrypt user_id'
  task encrypt_user_id: :environment do
    puts "Loading foods:\n"

    Checkin.where(:user_id.exists => true).order_by(date: :desc).each_with_index do |c, i|
      c.update(user_id: c[:user_id])

      puts i if i%100 == 0
    end

    puts "\nDone."
  end
end
