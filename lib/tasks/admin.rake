namespace :admin do
  #FIXME_AB: in the description write an example how to run this rake task with command line arguments.
  desc "create a new user admin"

  #FIXME_AB: read why we need to write :environment in the task below
  task new: :environment do |task, args|
    #FIXME_AB: Since admin is by default verified if created by rake task, set verified_at also
    user_params = {verified: true}
    if args.extras.count != 3
      puts "Invalid number of arguments passed please input the following details"
      puts "Enter a name:"
      user_params[:name] = STDIN.gets.chomp
      puts "Enter your email id"
      user_params[:email] = STDIN.gets.chomp
      puts "Enter a password"
      user_params[:password] = STDIN.gets.chomp
    else
      user_params[:name] = args.extras[0]
      user_params[:email] = args.extras[1]
      user_params[:password] = args.extras[2]
    end


    #FIXME_AB: here includes is not useful. Better something like Role.admin.users.create...
    Role.includes(:users).find_by(name: "admin").users.create!(user_params)
  end

end
