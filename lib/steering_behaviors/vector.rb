class SteeringBehaviors::Vector
  attr_reader :x, :y

  def initialize(x=0,y=0)
    @x = x.to_f
    @y = y.to_f
  end

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
    return if length == 1.0 || length == 0

    @x /= length
    @y /= length
  end

  def normalize
    if length != 0
      SteeringBehaviors::Vector.new(@x/length, @y/length)
    else
      SteeringBehaviors::Vector.new(0,0)
    end
  end

  def truncate!(max)
    return if length < max

    self.normalize!
    self.x *= max
    self.y *= max
  end

  def dot(vector)
    val = @x*vector.x + @y*vector.y
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
    SteeringBehaviors::Vector.sign(self,other)
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
    # puts "Rotating #{radians}"
    circle_cos = Math.cos(-radians)
    circle_sin = Math.sin(-radians)

    x_rot = circle_cos * x - circle_sin * y
    y_rot = circle_sin * x + circle_cos * y

    SteeringBehaviors::Vector.new(x_rot, y_rot)
  end

  def self.sign(v1, v2)
    if v1.y * v2.x > v1.x*v2.y
      return -1 # anti-clockwise
    else
      return 1 # clockwise
    end
  end

  def self.position_to_world_coords(point, heading, pos)
    local_angle = heading.radians + point.radians

    x = Math.sin(local_angle) * point.length
    y = Math.cos(local_angle) * point.length

    world_point = SteeringBehaviors::Vector.new(x,y) + pos
    world_point
  end

  def self.deg2rad(d)
    d * 0.017453292519943295 # Math::PI / 180.0
  end

  def self.rad2deg(r)
    r * 57.29577951308232 # 180.0 / Math::PI
  end

  def to_s
    format("Vector {[%.3f, %.3f] len %0.3f}", @x, @y, length)
  end
end
