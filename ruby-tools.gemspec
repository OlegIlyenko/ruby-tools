Gem::Specification.new do |s|
  s.name         = "ruby-tools"
  s.summary      = "My personal scripts to aid my needs!!!"
  s.description  = "Cool stuff!!!"
  s.version      = "1.0"
  s.author       = "Oleg Ilyenko"
  s.platform     = Gem::Platform::RUBY
  
  s.required_ruby_version = '>=2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w{lib}

  s.add_dependency "gli"
  s.add_dependency "slim"
  s.add_dependency "less"
  s.add_dependency "coffee-script"
  s.add_dependency "redcarpet"
  s.add_dependency "redcarpet"
  s.add_dependency "sinatra"
  s.add_dependency "sinatra-contrib"
  s.add_dependency "sinatra-websocket"
  s.add_dependency "launchy"
  s.add_dependency "trollop"

  s.has_rdoc    = false
end

