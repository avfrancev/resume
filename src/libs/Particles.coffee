
rand = (min,max) ->
  Math.floor (Math.random() * (max - min + 1)) + min

Vec = (@x = 0,@y) ->
  @y ?= @x

Vec::clone = ->
  new Vec @x,@y

Vec.rand = ->
  new Vec(
    _.random(-1,1)
    _.random(-1,1)
  )

Vec.fromAngle = (angle, magnitude) ->
  new Vec(
    magnitude * Math.cos(angle)
    magnitude * Math.sin(angle)
  )

Vec::add = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @x += v.x
  @y += v.y
  @

Vec::subs = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @x -= v.x
  @y -= v.y
  @

Vec::mult = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @x *= v.x
  @y *= v.y
  @

Vec::div = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @x = @x / v.x or 0
  @y = @y / v.y or 0
  @

Vec::normalise = ->
  @div @mag()


Vec::dot = (v,args...) ->
  @x * v.x + @y * v.y

Vec::rotate = (angle) ->
  nx = @x * Math.cos(angle) - (@y * Math.sin(angle))
  ny = @x * Math.sin(angle) + @y * Math.cos(angle)
  @x = nx
  @y = ny
  @

Vec::dist = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @clone().subs(v).mag()

Vec::distSq = (v,args...) ->
  v = new Vec(v, args...) if v !instanceof Vec
  @clone().subs(v).magSq()

Vec::limit = (max) ->
  mSq = @magSq()
  if mSq > max * max
    @div(Math.sqrt(mSq)).mult max
  this

Vec::invert = ->
  @x *= -1
  @y *= -1
  @

Vec::dir = ->
  Math.atan2(@y, @x)

Vec::mag = ->
  Math.sqrt(@x * @x + @y * @y)

Vec::magSq = ->
  @x*@x + @y*@y

################################
################################

Particle = ({
    @pos = new Vec 0,0
    @vel = new Vec 0,0
    @acc = new Vec 0,0
    @r = 1
    @color = '#fff'
    @mag = 1
  }) ->
  Object.assign @, arguments[0]

Particle::update = (o) ->
  force = new Vec _.random(-1,1), _.random(-1,1)
  # force.mult -0.5
  force.add (@pos.clone().mult(-.001))
  @vel.add force
  @vel.mult 0.97
  if o?.mouse
    force = (o.mouse.clone().mult(.0008))
  @mag = o.mouse.clone().subs(@pos).mag()
    # @vel.add o.mouse.clone()

  @vel.add force
  @vel.add new Vec 0,0.1
  # @pos = o?.mouse
  @pos.add @vel
  return


export {Particle, Vec}
