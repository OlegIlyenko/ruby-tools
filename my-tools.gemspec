Gem::Specification.new do |s|
  s.name         = "my-tools"
  s.summary      = "My personal scripts to aid my needs!!!"
  s.description  = "Cool stuff!!!"
  s.version     = "1.0"
  s.author      = "Oleg Ilyenko"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>=2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "gli"
  
  s.has_rdoc    = false
end

