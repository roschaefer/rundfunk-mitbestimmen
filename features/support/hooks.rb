After('@time-travel') do |scenario, block|
  Timecop.return
  puts "Welcome back in #{Time.now}"
end