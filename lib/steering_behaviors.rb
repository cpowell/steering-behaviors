class SteeringBehaviors
end

require 'steering_behaviors/common.rb'

require 'steering_behaviors/align.rb'
require 'steering_behaviors/arrive.rb'
require 'steering_behaviors/broadside.rb'
require 'steering_behaviors/evade.rb'
require 'steering_behaviors/flee.rb'
require 'steering_behaviors/match.rb'
require 'steering_behaviors/orthogonal.rb'
require 'steering_behaviors/pursue.rb'
require 'steering_behaviors/seek.rb'
require 'steering_behaviors/separation.rb'
require 'steering_behaviors/steering.rb'
require 'steering_behaviors/vector.rb'
require 'steering_behaviors/wander.rb'


SteeringBehaviors::VEC_ZERO    = SteeringBehaviors::Vector.new(0, 0)
SteeringBehaviors::VEC_UP_NEGY = SteeringBehaviors::Vector.new(0, -1)
SteeringBehaviors::VEC_UP_POSY = SteeringBehaviors::Vector.new(0, 1)
