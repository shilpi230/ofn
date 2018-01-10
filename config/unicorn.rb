# worker_processes 2 # amount of unicorn workers to spin up
# timeout 120         # restarts workers that hang for 30 seconds

worker_processes 2
working_directory "/home/#{ENV.fetch("WORKING_DIR_USER") { 'deploy' }}/openfoodnetwork"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html

preload_app true
timeout 120

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on

listen "/home/#{ENV.fetch("WORKING_DIR_USER") { 'deploy' }}/openfoodnetwork/tmp/sockets/unicorn.sock", :backlog => 64
pid "/home/#{ENV.fetch("WORKING_DIR_USER") { 'deploy' }}/openfoodnetwork/tmp/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/home/#{ENV.fetch("WORKING_DIR_USER") { 'deploy' }}/openfoodnetwork/log/unicorn.stderr.log"
stdout_path "/home/#{ENV.fetch("WORKING_DIR_USER") { 'deploy' }}/openfoodnetwork/log/unicorn.stdout.log"

before_fork do |server, worker|
  Signal.trap 'TERM' do
   puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
   Process.kill 'QUIT', Process.pid
  end
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

 defined?(ActiveRecord::Base) and
   ActiveRecord::Base.establish_connection(
     Rails.application.config.database_configuration[Rails.env]
   )
end
