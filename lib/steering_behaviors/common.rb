##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

module SteeringBehaviors::Common

  def compute_time_factor(forwardness, parallelness)
    f = interval_comparison(forwardness,  -0.707, 0.707)
    p = interval_comparison(parallelness, -0.707, 0.707)

    # Break the pursuit/evasion into nine cases, the cross product of the
    # quarry being [ahead, aside, or behind] us
    # and heading [parallel, perpendicular, or anti-parallel] to us.
    case f
    when 1
      case p
      when 1
        gen="ahead, parallel"
        tf = 1.8
      when 0
        gen="ahead, perpendicular"
        tf = 1.35
      when -1
        gen="ahead, anti-parallel"
        tf = 1.10
      end
    when 0
      case p
      when 1
        gen="aside, parallel"
        tf = 1.20
      when 0
        gen="aside, perpedicular"
        tf = 1.20
      when -1
        gen="aside, anti-parallel"
        tf = 1.20
      end
    when -1
      case p
      when 1
        gen="behind, parallel"
        tf = 1.20
      when 0
        gen="behind, perpendicular"
        tf = 1.20
      when -1
        gen="behind, anti-parallel"
        tf = 1.20
      end
    end

    return [gen, tf]
  end

  #=============================================================
  private

  def interval_comparison(x, lower_bound, upper_bound)
    return -1 if x < lower_bound
    return 1 if x > upper_bound
    return 0
  end
end
