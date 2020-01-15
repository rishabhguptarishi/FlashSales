namespace :admin do
  desc "create a new user admin to run type rake admin:new[your_name,your_email,password]"

  task new: :environment do |task, args|
    user_params = {verified: true, verified_at: Time.current}
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
    Role.admin.users.create!(user_params)
  end

end
