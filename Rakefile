desc "Builds and installs gem locally"
task :install_gem do
  gem_file = `ls *.gemspec`
  
  `gem build #{gem_file}`
  puts "Gem built"
  
  `gem install #{`ls *.gem`}`
  puts "Gem installed"
end
                            