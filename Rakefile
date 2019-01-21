require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop) do |task|
  # Make it easier to disable cops.
  task.options << '--display-cop-names'
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format progress'
end
