##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Vector
  TWOPI   = 6.283185307179586
  THREEPI = 9.42477796076938

  attr_reader :x, :y

  def initialize(x=0,y=0)
    @x = x.to_f
    @y = y.to_f
  end

  def clear_cache
    @length = nil
    @radians = nil
  end

  def ==(other)
    self.class == other.class && @x==other.x && @y==other.y
  end
  alias_method :eql?, :==

  def x=(x)
    @x = x.to_f
    clear_cache
  end

  def y=(y)
    @y = y.to_f
    clear_cache
  end

  def length
    # @length || @length = Math...
    @length ||= Math.sqrt(@x**2 + @y**2)
  end

  def +(v)
    SteeringBehaviors::Vector.new(@x + v.x, @y + v.y)
  end

  def /(n)
    SteeringBehaviors::Vector.new(@x/n, @y/n)
  end

  def *(n)
    SteeringBehaviors::Vector.new(@x*n, @y*n)
  end

  def -(v)
    SteeringBehaviors::Vector.new(@x - v.x, @y - v.y)
  end

  def delta(other)
    (( ( other.radians - self.radians + THREEPI ) % (TWOPI) ) - Math::PI).abs
  end

  def normalize!
    orig_length = length
    return self if orig_length == 1.0 || orig_length == 0

    @x /= orig_length
    @y /= orig_length
    clear_cache

    self
  end

  def normalize
    orig_length = length
    return self if orig_length == 1.0 || orig_length == 0

    SteeringBehaviors::Vector.new(@x/orig_length, @y/orig_length)
  end

  def truncate!(max)
    return self if length < max

    self.normalize!
    self.x *= max
    self.y *= max

    self
  end

  # A pure and correct dot product routine.
  # A · B = A.x * B.x + A.y * B.y
  def dot(b)
    val = @x*b.x + @y*b.y
  end

  # Unlike the 'pure' dot product above, this one ensures a -1.0..1.0 return value.
  # If you're doing dot products of normalized vectors and expecting a pure -1.0..1.0
  # return value for Math.acos() purposes, use this routine to avoid "Numerical argument
  # is out of domain" errors that creep in due to rounding errors.
  def clamped_dot(b)
    val = self.dot(b)

    val = 1.0 if val > 1.0
    val = -1.0 if val < -1.0

    val
  end

  def perpendicular
    SteeringBehaviors::Vector.new(@y, -@x)
  end

  def compass_bearing(y_down_more_positive=false)
    up = ( y_down_more_positive ? SteeringBehaviors::VEC_UP_NEGY : SteeringBehaviors::VEC_UP_POSY)

    theta = Math.acos(self.normalize.clamped_dot(up))

    theta *= -1 if @x < 0
    degs = SteeringBehaviors::Vector.rad2deg(theta)
    degs += 360 if degs < 0

    degs
  end

  def sign(other)
    SteeringBehaviors::Vector.sign(self, other)
  end

  def radians
    @radians ||= lambda do |x, y|
      theta = Math.acos(y/length)
      if x < 0
        theta *= -1
      end

      return theta % (TWOPI)
    end.call(@x, @y)
  end

  def from_compass_bearing!(brg)
    rad = SteeringBehaviors::Vector.deg2rad(brg)
    self.x = Math.sin(rad)
    self.y = Math.cos(rad)
    clear_cache
  end

  def rotate!(radians)
    clear_cache
    circle_cos = Math.cos(-radians)
    circle_sin = Math.sin(-radians)

    x_rot = circle_cos * x - circle_sin * y
    y_rot = circle_sin * x + circle_cos * y

    self.x, self.y = x_rot, y_rot
    self
  end

  def rotate(radians)
    circle_cos = Math.cos(-radians)
    circle_sin = Math.sin(-radians)

    x_rot = circle_cos * x - circle_sin * y
    y_rot = circle_sin * x + circle_cos * y

    SteeringBehaviors::Vector.new(x_rot, y_rot)
  end

  def self.sign(v1, v2)
    if v1.y * v2.x > v1.x*v2.y
      return -1 # clockwise
    else
      return 1 # anti-clockwise
    end
  end

  # def self.position_to_world_coords(point, heading_vec, pos)
  #   local_angle = heading_vec.radians + point.radians

  #   x = Math.sin(local_angle) * point.length
  #   y = Math.cos(local_angle) * point.length

  #   world_point = SteeringBehaviors::Vector.new(x,y) + pos
  #   world_point
  # end

  def self.deg2rad(d)
    d * 0.017453292519943295 # Math::PI / 180.0
  end

  def self.rad2deg(r)
    r * 57.29577951308232 # 180.0 / Math::PI
  end

  def self.from_compass_bearing(brg)
    rad = SteeringBehaviors::Vector.deg2rad(brg)
    SteeringBehaviors::Vector.new(Math.sin(rad), Math.cos(rad))
  end

  def to_s
    format("Vector {[%.7f, %.7f] len %0.7f}", @x, @y, length)
  end
end
