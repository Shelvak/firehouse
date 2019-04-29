root = "/firehouse"
working_directory root

pid "#{root}/tmp/pids.print_hub.unicorn.#{Time.new}.pid"
stderr_path "/logs/unicorn.log"
stdout_path "/logs/unicorn.log"

# listen '/tmp/unicorn.firehouse.socket', backlog: 1024
listen 8080, backlog: 1024
worker_processes 3
timeout 60

preload_app true

GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end


before_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
