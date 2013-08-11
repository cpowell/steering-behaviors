Gem::Specification.new do |s|
  s.name        = 'steering_behaviors'
  s.version     = '1.0.6'
  s.date        = '2013-08-11'
  s.summary     = "Steering behaviors in Ruby for autonomous game agents, useful for realistic character movement and emulating real-world and natural behaviors."
  s.description = <<-EOF
If you're building a game, you need your game agents and characters to move on their own. A standard way of doing this is with 'steering behaviors'. The seminal paper by Craig Reynolds established a core set of steering behaviors that could be utilized for a variety of common movement tasks and natural behaviors. This Ruby library can accomplish many/most of those tasks for your Ruby / JRuby game. The basic behaviors can be layered for more complicated and advanced behaviors, such as flocking and crowd movement.
  EOF
  s.authors     = ["Chris Powell"]
  s.email       = 'cpowell@prylis.com'
  s.files       = Dir['lib/**/*.rb']
  s.files       += Dir['[A-Z]*'] + Dir['test/**/*']
  s.homepage    = 'http://github.com/cpowell/steering-behaviors'
  s.license     = 'LGPL'
  s.rdoc_options = ["--main", "README.md"]
end
