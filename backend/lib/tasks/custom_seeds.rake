# lib/tasks/custom_seed.rake
namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern

      desc "Loads the seed data from #{filename}"
      task task_name => [:environment] do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
