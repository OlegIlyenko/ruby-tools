desc "Builds and installs gem locally"
task install_gem: [:build, :do_install]

task :build do
  `rm -f pkg/*`
  execute "gem build #{`ls *.gemspec`}"
  `mv *.gem pkg`
  log "Gem built"
end

task :do_install do
  execute "gem install #{`ls pkg/*.gem`.chomp} --ignore-dependencies"
  log "Gem installed"
end

def log message
  puts "[info] #{message}"
end

def execute command
  raise "Unsuccessful execution of `#{command.chomp}`" unless system command
end