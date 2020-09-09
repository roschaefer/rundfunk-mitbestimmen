require 'capistrano-db-tasks'
namespace :deploy do
  # SOURCE: https://gist.github.com/stevenyap/9130882
  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  # desc 'Restart Daemon'
  # task :restart_daemon do
  #   on roles(:web)  do |host|
  #     execute :svc, '-du ~/service/rundfunk-backend'
  #     execute :svc, '-du ~/service/rundfunk-sidekiq'
  #     info "Host #{host} restarting svc daemon"
  #   end
  # end
end
