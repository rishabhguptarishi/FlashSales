require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, { error: "log/cron_error.log", standard: 'log/cron.log' }

set :environment, Rails.env


every :day, at: [ Time.use_zone('New Delhi') { Time.zone.parse("10:00am") }.in_time_zone("New Delhi") ] do
  rake "deals:publish"
end

every 5.minutes do
  rake "order:delete_hanged_orders"
end
