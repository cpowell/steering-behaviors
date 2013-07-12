Gem::Specification.new do |s|
  s.name        = 'steering_behaviors'
  s.version     = '0.0.5'
  s.date        = '2013-07-11'
  s.summary     = "Steering behaviors in Ruby for autonymous game agents"
  s.description = <<-EOF
  EOF
  s.authors     = ["Chris Powell"]
  s.email       = 'cpowell@prylis.com'
  s.files       = Dir['lib/**/*.rb']
  s.files       += Dir['[A-Z]*'] + Dir['test/**/*']
  s.homepage    = 'http://github.com/cpowell/steering-behaviors'
  s.license     = 'LGPL'
  s.rdoc_options = ["--main", "README.md"]
end
