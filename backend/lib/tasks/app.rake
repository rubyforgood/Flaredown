namespace :app do
  desc 'flaredown | setup application'
  task setup: :environment do
    setup
  end

  desc 'flaredown | invite beta user to join in'
  task invite: :environment do
    invite
  end

  desc "flaredown | delete a user's account"
  task delete_account: :environment do
    delete_account
  end

  class OperationAbortedException < StandardError; end

  def invite
    email = prompt 'Please insert email address: '
    User.invite!(email: email)
  end

  def setup
    puts 'This will create the necessary stuff. You will lose any previous data stored'
    # NOTE: asking for confirmation is actually a good idea
    # as DBs will be purged but it messes with CI atm
    ask_to_continue unless Rails.test?

    build_database

  rescue OperationAbortedException
    puts "\nQuitting...".red
    exit 1
  end

  def build_database
    header 'build database'
    Rake::Task['db:mongoid:purge'].invoke

    if Rails.env.development?
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
    end
    Rake::Task['db:structure:load'].invoke
    Rake::Task['db:seed'].invoke
  rescue ::PG::ObjectInUse => e
    puts "\n#{e.message}.".red
  end

  def header(message)
    puts ">>> #{message}".bold.blue
  end

  def ask_to_continue
    answer = prompt('Do you want to continue (yes/no)? ', %w(yes no))
    fail OperationAbortedException unless answer.eql?('yes')
  end

  def prompt(message, choices = nil)
    begin
      print(message)
      answer = STDIN.gets.chomp
    end while choices.present? && !choices.include?(answer)
    answer
  rescue Interrupt
    raise OperationAbortedException
  end

  def delete_account
    puts "DANGER ZONE: This action can't be undone!".yellow
    email = prompt "Please insert user's email address: "
    user = User.find_by(email: email)
    if user.nil?
      puts "No user found for the entered email address".red
    else
      user.destroy!
      puts "User account successfully deleted".blue
    end
  rescue OperationAbortedException
    puts "\nQuitting..."
    exit 1
  end

end
