# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/rails/social"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/home/rails/social/pids/unicorn.pid"

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/.sock", :backlog => 64
listen 8080, :tcp_nopush => true

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/rails/social/log/unicorn.log"
stdout_path "/home/rails/social/log/unicorn.log"

# Number of processes
# Rule of thumb: 2x per CPU core available
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
