gem 'minitest'
require 'minitest/autorun'

$:.push File.expand_path('../../lib/', __FILE__)
require 'steering_behaviors'
require 'steering_behaviors/vector.rb'

# ruby ./test/vector_test.rb

class VectorTest < MiniTest::Unit::TestCase
  def setup
    @v = SteeringBehaviors::Vector.new(0, 1.0)
  end

  def test_setters
    @v.x=5
    assert_equal(5, @v.x)

    @v.y=10
    assert_equal(10, @v.y)
  end

  def test_equality
    @v2 = SteeringBehaviors::Vector.new(0, 1.0)
    assert_equal(@v, @v2)

    @v2 = SteeringBehaviors::Vector.new(5, 1.0)
    refute_equal(@v, @v2)
  end

  def test_length_calculation
    assert_equal(1, @v.length)

    @v.x=10
    @v.y=10
    assert_equal(14.142135623730951, @v.length)

    @v.x=-10
    assert_equal(14.142135623730951, @v.length)
  end

  def test_addition
    @v2 = SteeringBehaviors::Vector.new(5, -5)
    @v+= @v2

    assert_equal(5, @v.x)
    assert_equal(-4, @v.y)
    assert_equal(6.4031242374328485, @v.length)
  end

  def test_subtraction
    @v2 = SteeringBehaviors::Vector.new(5, -5)
    @v-= @v2

    assert_equal(-5, @v.x)
    assert_equal(6, @v.y)

    assert_equal(7.810249675906654, @v.length)
  end

  def test_multiplication
    @v *= 10
    assert_equal(0, @v.x)
    assert_equal(10.0, @v.y)

    @v *= 0.5
    assert_equal(0, @v.x)
    assert_equal(5.0, @v.y)

    assert_equal(5.0, @v.length)
  end

  def test_division
    @v /= 2
    assert_equal(0, @v.x)
    assert_equal(0.5, @v.y)

    @v /= 0.2
    assert_equal(0, @v.x)
    assert_equal(2.5, @v.y)

    assert_equal(2.5, @v.length)
  end

  def test_delta
    other = SteeringBehaviors::Vector.new(1.0, 0)
    assert_equal(Math::PI/2, @v.delta(other))

    assert_equal(Math::PI/2, other.delta(@v))

    other = SteeringBehaviors::Vector.new(0.1, 1.0)
    assert_in_delta(0.1, other.delta(@v), 0.01)

    other = SteeringBehaviors::Vector.new(-0.1, 1.0)
    assert_in_delta(0.1, other.delta(@v), 0.01)

    other = SteeringBehaviors::Vector.new(-0.1, -1.0)
    assert_in_delta(3.04, other.delta(@v), 0.01)

    other = SteeringBehaviors::Vector.new(0.1, -1.0)
    assert_in_delta(3.04, other.delta(@v), 0.01)
  end

  def test_bang_normalization
    res=@v.normalize!
    assert_equal(@v, res)
    assert_equal(1.0, @v.length)

    @v = SteeringBehaviors::Vector.new(0, 0)
    assert_equal(0, @v.length)
    res=@v.normalize!
    assert_equal(@v, res)
    assert_equal(0.0, @v.length)

    @v = SteeringBehaviors::Vector.new(1.0, 0)
    assert_equal(1, @v.length)
    res=@v.normalize!
    assert_equal(@v, res)
    assert_equal(1.0, @v.length)

    @v = SteeringBehaviors::Vector.new(0, 1.0)
    assert_equal(1, @v.length)
    res=@v.normalize!
    assert_equal(@v, res)
    assert_equal(1.0, @v.length)

    @v = SteeringBehaviors::Vector.new(10, 10)
    assert_equal(14.142135623730951, @v.length)
    res=@v.normalize!
    assert_equal(@v, res)
    assert_in_delta(1.0, @v.length, 0.01)

    @v = SteeringBehaviors::Vector.new(3, 4)
    assert_equal(5, @v.length)
    res=@v.normalize!
    assert_equal(@v, res)
    assert_equal(1.0, @v.length)

    @v = SteeringBehaviors::Vector.new(0.5, 1.0)
    res=@v.normalize!
    assert_in_delta(1.0, @v.length, 0.01)
  end

  def test_normalization
    res=@v.normalize
    assert_equal(1.0, @v.length)

    @v = SteeringBehaviors::Vector.new(0, 0)
    assert_equal(0, @v.length)
    res=@v.normalize
    assert_equal(@v, res)
    assert_equal(0.0, res.length)

    @v = SteeringBehaviors::Vector.new(1.0, 0)
    assert_equal(1, @v.length)
    res=@v.normalize
    assert_equal(@v, res)
    assert_equal(1.0, res.length)

    @v = SteeringBehaviors::Vector.new(0, 1.0)
    assert_equal(1, @v.length)
    res=@v.normalize
    assert_equal(@v, res)
    assert_equal(1.0, res.length)

    @v = SteeringBehaviors::Vector.new(10, 10)
    assert_equal(14.142135623730951, @v.length)
    res=@v.normalize
    refute_equal(@v, res)
    assert_in_delta(14.142, @v.length, 0.01)
    assert_in_delta(1.0, res.length, 0.01)

    @v = SteeringBehaviors::Vector.new(3, 4)
    assert_equal(5, @v.length)
    res=@v.normalize
    refute_equal(@v, res)
    assert_equal(5.0, @v.length)
    assert_equal(1.0, res.length)
  end

  def test_truncation
    res = @v.truncate!(500)
    assert_equal(1.0, res.length)

    @v = SteeringBehaviors::Vector.new(10, 10)
    assert_equal(14.142135623730951, @v.length)
    res = @v.truncate!(15)
    assert_equal(14.142135623730951, res.length)

    res = @v.truncate!(9)
    assert_equal(9.0, res.length)
  end

  def test_dot_product
    @v1 = SteeringBehaviors::Vector.new(0.5, 1)
    @v2 = SteeringBehaviors::Vector.new(1.0, 0.5)
    assert_equal(1.0, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 1.0)
    @v2 = SteeringBehaviors::Vector.new(1.0, 1.0)
    assert_equal(2.0, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0.708, 0.707)
    @v2 = SteeringBehaviors::Vector.new(0.707, 0.707)
    assert_equal(1.000405, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 0)
    @v2 = SteeringBehaviors::Vector.new(0, 1.0)
    assert_equal(0, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0, 1.0)
    @v2 = SteeringBehaviors::Vector.new(-1.0, 0)
    assert_equal(0, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0, 1.0)
    @v2 = SteeringBehaviors::Vector.new(0.707, 0.707)
    @v2.normalize!
    assert_equal(0.7071067811865476, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 0)
    @v2 = SteeringBehaviors::Vector.new(-0.707, 0.707)
    @v2.normalize!
    assert_equal(-0.7071067811865476, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 0)
    @v2 = SteeringBehaviors::Vector.new(-0.707, -0.707)
    @v2.normalize!
    assert_equal(-0.7071067811865476, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0.5, 0.866)
    @v1.normalize!
    @v2 = SteeringBehaviors::Vector.new(0.866, 0.5)
    @v2.normalize!
    assert_equal(0.86603810567665, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(500, 500)
    @v2 = SteeringBehaviors::Vector.new(-14, 75)
    assert_equal(30500, @v1.dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(-0.5, -0.5)
    @v2 = SteeringBehaviors::Vector.new(2.2, 2.2)
    assert_equal(-2.2, @v1.dot(@v2))
  end

  def test_clamped_dot_product
    @v1 = SteeringBehaviors::Vector.new(0.5, 1)
    @v2 = SteeringBehaviors::Vector.new(1.0, 0.5)
    assert_equal(1.0, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0.708, 0.707)
    @v2 = SteeringBehaviors::Vector.new(0.707, 0.707)
    assert_equal(1.0, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0, 1.0)
    @v2 = SteeringBehaviors::Vector.new(-1.0, 0)
    assert_equal(0, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0, 1.0)
    @v2 = SteeringBehaviors::Vector.new(0.707, 0.707)
    @v2.normalize!
    assert_equal(0.7071067811865476, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 0)
    @v2 = SteeringBehaviors::Vector.new(-0.707, 0.707)
    @v2.normalize!
    assert_equal(-0.7071067811865476, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(1.0, 0)
    @v2 = SteeringBehaviors::Vector.new(-0.707, -0.707)
    @v2.normalize!
    assert_equal(-0.7071067811865476, @v1.clamped_dot(@v2))

    @v1 = SteeringBehaviors::Vector.new(0.5, 0.866)
    @v1.normalize!
    @v2 = SteeringBehaviors::Vector.new(0.866, 0.5)
    @v2.normalize!
    assert_equal(0.86603810567665, @v1.clamped_dot(@v2))
  end


  def test_perpendicular
    @v2 = @v.perpendicular
    assert_equal(1.0, @v2.x)
    assert_equal(0, @v2.y)
  end

  def test_instance_sign
    v1 = SteeringBehaviors::Vector.from_compass_bearing(45)
    v2 = SteeringBehaviors::Vector.from_compass_bearing(115)

    assert_equal(-1, v1.sign(v2))
    assert_equal(1, v2.sign(v1))
  end

  def test_compass_bearing
    @v = SteeringBehaviors::Vector.new(5, 5)
    assert_in_delta(45, @v.compass_bearing, 0.1)

    @v = SteeringBehaviors::Vector.new(-2, 10)
    assert_in_delta(349, @v.compass_bearing, 0.5)

    @v = SteeringBehaviors::Vector.new(5, 5)
    assert_in_delta(135, @v.compass_bearing(true), 0.1)

    @v = SteeringBehaviors::Vector.new(-2, 10)
    assert_in_delta(191, @v.compass_bearing(true), 0.5)
  end

  def test_radians
    assert_equal(0, @v.radians)

    @v = SteeringBehaviors::Vector.new(1.0, 0)
    assert_equal(Math::PI/2, @v.radians)

    @v = SteeringBehaviors::Vector.new(0, 1.0)
    assert_equal(0, @v.radians)

    @v = SteeringBehaviors::Vector.new(0.707, -0.707)
    assert_equal(Math::PI/4*3, @v.radians)

    @v = SteeringBehaviors::Vector.new(-0.707, 0.707)
    assert_equal(Math::PI/4*7, @v.radians)
  end

  def test_bang_from_compass_bearing
    @v.from_compass_bearing!(45)
    assert_in_delta(0.707, @v.x, 0.001)
    assert_in_delta(0.707, @v.y, 0.001)

    @v.from_compass_bearing!(135)
    assert_in_delta(0.707, @v.x, 0.001)
    assert_in_delta(-0.707, @v.y, 0.001)

    @v.from_compass_bearing!(270)
    assert_in_delta(-1.0, @v.x, 0.001)
    assert_in_delta(0, @v.y, 0.001)
  end

  def test_bang_rotate
    assert_equal(0, @v.radians)
    @v.rotate!(Math::PI)
    assert_equal(Math::PI, @v.radians)
    assert_in_delta(0.0, @v.x, 0.0001)
    assert_equal(-1.0, @v.y)

    @v.rotate!(Math::PI/2)
    assert_equal(Math::PI*1.5, @v.radians)
    assert_in_delta(-1.0, @v.x, 0.0001)
    assert_in_delta(0, @v.y, 0.0001)
  end

  def test_rotate
    assert_equal(0, @v.radians)
    v2 = @v.rotate(Math::PI)
    assert_equal(0, @v.radians)
    assert_equal(Math::PI, v2.radians)
    assert_in_delta(0.0, v2.x, 0.0001)
    assert_equal(-1.0, v2.y)

    v3 = v2.rotate(Math::PI/2)
    assert_equal(Math::PI*1.5, v3.radians)
    assert_in_delta(-1.0, v3.x, 0.0001)
    assert_in_delta(0, v3.y, 0.0001)
  end

  def test_rotate_never_returns_negative_rads
    assert_equal(0, @v.radians)

    new_vec = @v.rotate(-Math::PI/2)
    assert_equal(3.0/2*Math::PI, new_vec.radians)

    new_vec.rotate!(-Math::PI)
    assert_in_delta(Math::PI/2.0, new_vec.radians, 0.0001)

    new_vec.rotate!(2.0*Math::PI)
    assert_in_delta(Math::PI/2.0, new_vec.radians, 0.0001)

    new_vec.rotate!(-2.0*Math::PI)
    assert_in_delta(Math::PI/2.0, new_vec.radians, 0.0001)
  end

  def test_degree_to_radian_conversion
    assert_equal Math::PI/4, SteeringBehaviors::Vector.deg2rad(45)
    assert_equal Math::PI/2, SteeringBehaviors::Vector.deg2rad(90)
    assert_equal Math::PI, SteeringBehaviors::Vector.deg2rad(180)
    assert_equal Math::PI*14/8, SteeringBehaviors::Vector.deg2rad(315)
  end

  def test_radian_to_degree_conversion
    assert_equal 45, SteeringBehaviors::Vector.rad2deg(Math::PI/4)
    assert_equal 90, SteeringBehaviors::Vector.rad2deg(Math::PI/2)
    assert_equal 180, SteeringBehaviors::Vector.rad2deg(Math::PI)
    assert_equal 315, SteeringBehaviors::Vector.rad2deg(Math::PI*14/8)
  end

  def test_class_from_compass_bearing
    v = SteeringBehaviors::Vector.from_compass_bearing(349)
    assert_equal(-0.19080899537654467, v.x)
    assert_equal(0.981627183447664, v.y)

    v = SteeringBehaviors::Vector.from_compass_bearing(270)
    assert_in_delta(-1.0, v.x, 0.0001)
    assert_in_delta(0, v.y, 0.0001)
  end

  def test_class_sign
    v1 = SteeringBehaviors::Vector.from_compass_bearing(45)
    v2 = SteeringBehaviors::Vector.from_compass_bearing(115)

    assert_equal(-1, SteeringBehaviors::Vector.sign(v1, v2))
    assert_equal(1, SteeringBehaviors::Vector.sign(v2, v1))
  end

end
