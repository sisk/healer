desc "Restart Passenger (add DEBUG=true to launch debugger)"
task :restart do
  system("touch tmp/restart.txt")
  system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
end