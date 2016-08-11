require 'byebug'
module ChildProcess
  module Unix
    class Process < AbstractProcess
      def interrupt
        send_signal "SIGINT"
      end
    end
  end
end

class ApplicationManager
  require 'childprocess'
  attr_accessor :rails, :ember, :rails_log, :ember_log

  def initialize
    @rails = ChildProcess.build("sh", "-c", "BUNDLE_GEMFILE=Gemfile bundle exec rails s -e test")
    @rails.leader = true
    @rails.cwd = Cukes.config.rails_root
    @rails_log = @rails.io.stdout = @rails.io.stderr = Tempfile.new('rails-log')

    @ember = ChildProcess.build("ember", "serve", "--proxy", "http://localhost:3000")
    @ember.leader = true
    @ember.cwd = Cukes.config.ember_root
    @ember_log = @ember.io.stdout = @ember.io.stderr = Tempfile.new("ember-log")
  end

  def start_stack
    puts "Bringing the Applications Online, sit tight"
    rails.start
    ember.start
    wait_for_processes_started
    puts "Applications Online - Happy Cuking"
  end

  def stop_stack
    puts "Stopping the Applications, hang on"
    rails.interrupt
    ember.interrupt
    wait_for_processes_to_exit
    puts "All done! Hope they're all passes (::) (::) (::)"
  end


private

  def wait_for_processes_started
    begin
      Timeout::timeout(Cukes.config.startup_timeout) do
        loop do
           break if processes_started?
        end
      end
    rescue Timeout::Error => e
      rails.interrupt
      ember.interrupt
      wait_for_processes_to_exit
      raise "Unable to start the application"
    end
  end

  def wait_for_processes_to_exit
    begin
      Timeout::timeout(5) do
        loop { break if rails.exited? && ember.exited? }
      end
    rescue Errno::ESRCH => e
      # Already stopped the process, no biggie
    rescue Timeout::Error => e
      raise "Unable to exit processes. pids: #{rails.pid}, #{ember.pid}"
    end
  end

  def processes_started?
    backend_ready = open(rails_log).read.include?(Cukes.config.rails_started_message)
    frontend_ready = open(ember_log).read.include?(Cukes.config.ember_started_message)
    backend_ready && frontend_ready
  end
end
