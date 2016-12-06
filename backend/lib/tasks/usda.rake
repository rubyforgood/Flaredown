namespace :usda do
  FOODS_FILE = Rails.root.join('spec/fixtures/usda/FOOD_DES.txt')
  SURROUNDER = /\A~|~\z/
  BLANK_STRING = ''
  PROGRESS_FAIL = 'x'
  PROGRESS_SUCCESS = '.'

  desc 'Load USDA data'
  task load: :environment do
    puts "Loading foods:\n"

    I18n.locale = :en

    FOODS_FILE.readlines.each do |food|
      begin
        parsed_food = food.encode('UTF-8', invalid: :replace).split('^')

        created_food = Food.find_or_create_by(ndb_no: strip(parsed_food.first)) do |f|
          f.comname = strip(parsed_food[4])
          f.sciname = strip(parsed_food[9])
          f.long_desc = strip(parsed_food[2])
          f.shrt_desc = strip(parsed_food[3])
        end
      rescue Exception => e
        puts food

        raise e
      end

      printf created_food.persisted? ? PROGRESS_SUCCESS : PROGRESS_FAIL
    end

    puts "\nDone."
  end

  def strip(str)
    str.gsub(SURROUNDER, BLANK_STRING)
  end
end
