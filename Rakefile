require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  # Make it easier to disable cops.
  task.options << '--display-cop-names'

  # Abort on failures (fix your code first)
  task.fail_on_error = false
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format progress'
end
