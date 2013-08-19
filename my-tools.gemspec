Gem::Specification.new do |s|
  s.name         = "my-tools"
  s.summary      = "My personal scripts to aid my needs!!!"
  s.description  = "Cool stuff!!!"
  s.version     = "1.0"
  s.author      = "Oleg Ilyenko"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>=2.0'
  s.files       = Dir['**/**']
  s.executables = ['my-test']
  s.test_files  = Dir["test/test*.rb"]
  s.has_rdoc    = false
end