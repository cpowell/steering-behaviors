class SteeringBehaviors::Vector
  attr_reader :x, :y

  def initialize(x=0,y=0)
    @x = x.to_f
    @y = y.to_f
  end

  def ==(other)
    self.class == other.class && @x==other.x && @y==other.y
  end
  alias_method :eql?, :==

  def x=(x)
    @x = x.to_f
  end

  def y=(y)
    @y = y.to_f
  end

  def length
    Math.sqrt(@x**2 + @y**2)
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

  def normalize!
    orig_length = length
    return self if orig_length == 1.0 || orig_length == 0

    @x /= orig_length
    @y /= orig_length

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

  # A · B = A.x * B.x + A.y * B.y
  def dot(b)
    val = @x*b.x + @y*b.y
    val = 1.0 if val > 1.0
    val = -1.0 if val < -1.0

    val
  end

  def perpendicular
    SteeringBehaviors::Vector.new(@y, -@x)
  end

  def compass_bearing(y_down_more_positive=false)
    if y_down_more_positive
      up = SteeringBehaviors::Vector.new(0, -1)
    else
      up = SteeringBehaviors::Vector.new(0, 1)
    end

    theta = Math.acos(self.normalize.dot(up))

    theta *= -1 if @x < 0
    degs = SteeringBehaviors::Vector.rad2deg(theta)
    degs += 360 if degs < 0

    degs
  end

  def sign(other)
    SteeringBehaviors::Vector.sign(self, other)
  end

  def radians
    theta = Math.acos(@y/length)
    if @x < 0
      theta *= -1
    end

    theta % (2 * Math::PI)
  end

  def from_compass_bearing!(brg)
    rad = SteeringBehaviors::Vector.deg2rad(brg)
    self.x = Math.sin(rad)
    self.y = Math.cos(rad)
  end

  def rotate!(radians)
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
