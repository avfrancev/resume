<template lang="pug">
  .landing(ref="landing")
    .canvas(ref="canvas")
    .intro(
      ref="intro"
      @mousemove="mousemove"
      )
      .text
        .hello Hello, I'm #[span.highlight Alex Francev],
        .under front-end developer who loves UI effects, animation, and dynamic user experience.
        .actions
          button.btn Action
</template>

<script lang="coffee">
  Sketch = require 'sketch-js'
  import { Particle, Vec } from '@/libs/Particles.coffee'

  sketch = {}
  particles = []

  export default {
    name: "landing"
    data: ->
      r: 111
    methods:
      mousemove: (e) ->
        # sketch.mouse.x = e.clientX
        # sketch.mouse.y = e.clientY
        sketch.mouse.x = e.pageX
        sketch.mouse.y = e.pageY

    mounted: ->
      sketch = Sketch.create {
        container: @$refs.canvas
        interval: 2
        filter: 'blur(20px)'
      }
      sketch.imageSmoothingQuality = 'high'
      sketch.globalCompositeOperation = 'lighter'
      sketch.mouse.x = sketch.width / 2
      sketch.mouse.y = sketch.height / 1.3
      sketch.c = new Vec sketch.width / 2, sketch.height / 2
      PC = sketch.width / 10
      particles = [0...PC].map ->
        new Particle
          pos: new Vec _.random(-200,200)+sketch.width/2, _.random(-200,200)+sketch.height/2
          m: _.random 2,10
          r: 6

      sketch.update = ->
        m = new Vec @mouse.x, @mouse.y
        for p,i in particles
          force = new Vec _.random(-10,10), _.random(-10,10)
          force.mult 0.025
          p.vel.add force
          p.vel.mult 0.99
          dx = p.pos.clone().subs(m)
          force.add dx.mult(-.001/p.m)
          # force.add dx.mult(-p.m/100000)
          p.vel.add force

          l = particles.length
          x = i*@width/l + @width/l/2
          distX = Math.abs x - m.x
          maxDist = 100

          dx = new Vec(x,p.pos.y).subs(m)
          dist = dx.mag()

          # if distX < maxDist
          #   radius = 2 + ( ( maxDist - distX ) / maxDist ) * 10
          #   p.r = if radius > 10 then 10 else radius
          # else
          #   p.r = 2

          # distY = Math.abs p.pos.y - m.y
          # if distY < maxDist
          #   radius = 2 + ( ( maxDist - distY ) / maxDist ) * 3
          #   p.r += if radius > 3 then 3 else radius
          # else
          #   p.r = 2

          # p.r = 12 + ( ( maxDist - dist ) / maxDist ) * 10
          # if dist < 200
          p.r = _.clamp (p.m)/dist*100, 2, 10

          # p.r = 2 + dx.mag()*101

          # force = m.clone().mult(.0008)
          # @mag = o.mouse.clone().subs(@pos).mag()
            # @vel.add o.mouse.clone()

          p.vel.add force
          # p.vel.add new Vec 0,0.01
          # p.pos = o?.mouse
          p.pos.add p.vel
        # particles[PC//2].pos = m
        # particles[PC//2].r = 100

      sketch.draw = ->
        l = particles.length
        for p,i in particles
          x = i*@width/l + @width/l/2

          @fillStyle = 'rgba(255,255,255,0.05)'
          @strokeStyle = "rgba(255,255,255,#{p.m/101})"
          # @lineWidth = p.m/100
          @lineWidth = 1
          @beginPath();
          @setLineDash([10+(p.pos.y/10),10]);
          @moveTo(x, p.pos.y);
          @lineTo(x, 0);
          @stroke();

          @beginPath();
          @setLineDash([10+((@height - p.pos.y)/10),10]);
          @moveTo(x, p.pos.y);
          @lineTo(x, @height);
          @stroke();


          # @fillStyle = "hsla(335, 69%, 45%, #{p.m/50})"
          @fillStyle = "hsla(150, 100%, 65%, #{p.m*p.r/100})"
          @beginPath()
          @arc( x, p.pos.y, 1+p.r/5, 0, TWO_PI )
          @fill()

          # @beginPath()
          # @arc( p.pos.x, p.pos.y, p.r, 0, TWO_PI )
          # @fillStyle = 'rgba(255,255,255,0.1)'
          # @fill()

          @fillStyle = "hsla(150, 100%, 65%, #{p.m*p.r/300})"
          # grd = @createRadialGradient(x, p.pos.y, 1, x, p.pos.y, 120)
          # grd.addColorStop(0, "hsla(150, 100%, 65%, #{p.m/150})")
          # grd.addColorStop(0.9, "transparent")
          # @fillStyle = grd
          @beginPath()
          @ellipse(x, p.pos.y, 0.5, 1+p.r*5, 0, 0, 2 * Math.PI)
          @fill()

  }
</script>

<style lang="stylus" scoped>



  .landing
    position: relative
    min-height: 100vh
    color: c0
    background-image: url('~@/assets/classy-fabric.png'),
      -webkit-radial-gradient(50% 20%, circle cover, transparent 20%, darken(c1,40%) 80%)
    background-repeat: repeat, no-repeat
    background-size: auto, 100% 100%

  .canvas
    position: absolute
    width: 100%
    height: 100%
    left: 0
    top: 0
    canvas
      position: absolute
      width: 100%
      height: 100%
      left: 0
      top: 0


  .intro
    position: absolute
    width: 100%
    min-height: 100vh
    display: flex
    align-items: center
    justify-content: center
    font-family: 'Fira Code', monospace
    .highlight
      font-weight: 800
      color: c8
      // white-space: nowrap
    .text
      color: #fff
      display: flex
      flex-direction: column
      align-items: center
      text-align: center
      text-shadow: 0 1px 3px darken(c1,60%)
      min-width: 50%
      max-width: 100%
      width: calc((420px - 100%) * 420)
      @media (max-width: 400px)
        width: auto
        margin: 0 20px

      .hello
        font-weight: 300
        margin-bottom: vr(0.5, 1.2rem, 2.3rem)
        // margin-bottom: @font-size
        font-size: responsive 1.2rem 2.3rem
        line-height: responsive 1.6rem 1.8rem
        // line-height: responsive


      .under
        line-height: 1.4rem
        max-width: 600px
        margin-bottom: vr(0.5, 1.2rem, 2.3rem)
        font-size: responsive 0.8rem 1.1rem
        line-height: responsive 1.2rem 1.8rem

        // line-height-range: 420px 1280px
        // line-height-range: 420px 1280px


</style>
