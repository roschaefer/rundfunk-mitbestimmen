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

  desc 'Restart Daemon'
  task :restart_daemon do
    on roles(:web) do |host|
      execute :supervisorctl, 'reread'
      execute :supervisorctl, 'update'
      execute :supervisorctl, 'restart rundfunk-backend'
      execute :supervisorctl, 'restart rundfunk-sidekiq'
      info "Host #{host} restarting svc daemon"
    end
  end

  after :finished, :restart_daemon
end
