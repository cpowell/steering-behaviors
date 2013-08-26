# Steering Behaviors for Autonomous Game Agents in Ruby

If you're building a game, you need your game agents and characters to move on their own. A standard way of doing this is with 'steering behaviors'.

The seminal paper by Craig Reynolds established a core set of steering behaviors that could be utilized for a variety of common movement tasks. This Ruby library can accomplish many/most of those tasks for your Ruby / JRuby game.

The basic behaviors can be layered for more complicated and advanced behaviors, such as flocking and crowd movement.

## How it works

The steering behaviors expect to operate on a 'kinematic' thing. That is, the steerable object must expose several required parameters such as position vector, velocity vector, etc. These vectors are altered by the steering force, and then your movement engine simply repositions the object accordingly.

## Supported stering behaviors

The library supports a variety of steering behaviors. Some of these are the 'canonical' steering behaviors documented at Craig Reynold's website (see References, below). Others are behaviors documented in game programming books or behaviors that I have found useful for my own game programming needs:

* Seek: aim for and reach the specified point at top speed
* Flee: head away from the specified point at top speed (the opposite of Seek)
* Arrive: aim for and reach the specified point, decelerating gracefully to arrive with zero velocity
* Pursue: given a moving target, anticipate its future position and intercept the target intelligently
* Evade: given a moving target, anticipate its future position and avoid the target intelligently (the opposite of Pursue)
* Wander: move about the plain in a 'random walk' way
* Separate: predictively steer to avoid collision with another agent, based on the closest point of approach
* Align: align my course with the target's course, without altering my speed
* Match: match my course and speed to those of the target
* Broadside: expose my side to the target in the manner of a ship's broadside; useful for orbiting or exposing weapons, say
* Orthogonal: steer for a course that is 90 degrees from the target's

## Project status

This is working, functional software, suitable for use in your own game or application.

Additional steering behaviors, such as flocking and following, are planned.

Watch the [changelog](http://github.com/cpowell/steering-behaviors/blob/master/CHANGELOG.md) for news.

## Gem installation

I recommend you clone the Git repository and browse the examples and source code to fully understand how the behaviors work.

But if / when you want to use this in your own project, the easiest way to do so is via the Gem:
```
gem install steering_behaviors
```

Then in your code:
```
require 'steering_behaviors'
```

The gem is fully namespaced to prevent collisions. See the examples for usage details.

## Included examples

The `examples` directory contains working examples of each of the behaviors. The examples themselves are, of course, graphical and leverage Slick2D and JRuby. All the necessary libraries to run the examples are included in this Git repository; you'll just need to install JRuby. (I recommend rvm.)
```
rvm install jruby
```

Then, to run the examples:
```
./examples/run_examples.sh
```

Note that JRuby is not a dependency for the Steering Behaviors themselves, only for the bundled examples which rely on JRuby / Slick2D for animation.

By the way, the examples are not DRY at all and are highly repetitive from one example to the next; this is by design. They are intended to each be somewhat self-contained and readable without you having to flip between too many files to gain an understanding of what is going on.

## References used in the creation of this software
* "Autonomous Behaviors for Autonomous Characters" by Craig Reynolds [(Explanation and demos)](http://www.red3d.com/cwr/steer/)
* "Programming Game AI by Example" by Mat Buckland [(Amazon link)](http://www.amazon.com/Programming-Game-Example-Mat-Buckland/dp/1556220782)



[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/cpowell/steering-behaviors/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

