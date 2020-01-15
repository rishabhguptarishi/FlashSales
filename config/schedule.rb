every :day, at: "10:00am", by_timezone: 'Asia (Chennai)' do
  rake "deals:publish"
end
