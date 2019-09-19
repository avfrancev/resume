<template lang="pug">
  .landing(ref="landing")
    .canvas(ref="canvas")
    .intro(ref="intro")
      .text Hello, I'm
        span.highlight  Alex Francev
        |,
        br
        | a full-stack web developer.
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
    mounted: ->
      sketch = Sketch.create {
        container: @$refs.canvas
        # eventTarget: @$refs.intro
        interval: 2
      }
      sketch.globalCompositeOperation = 'lighter'
      sketch.mouse.x = sketch.width / 2
      sketch.mouse.y = sketch.height / 2
      sketch.c = new Vec sketch.width / 2, sketch.height / 2

      particles = [0...100].map ->
        new Particle
          pos: new Vec _.random(-200,200)+sketch.width/2, _.random(-200,200)+sketch.height/2
          m: _.random 1,10
          r: 3
          mag: 1

      sketch.update = ->
        m = new Vec @mouse.x, @mouse.y
        for p,i in particles
          force = new Vec _.random(-10,10), _.random(-10,10)
          force.mult 0.025
          p.vel.add force
          p.vel.mult 0.99
          dx = p.pos.clone().subs(m)
          # dist = dx.mag()
          force.add dx.mult(-.00003*p.m)
          p.vel.add force

          l = particles.length
          x = i*@width/l + @width/l/2
          distX = Math.abs x - m.x
          maxDist = 100

          if distX < maxDist
            radius = 2 + ( ( maxDist - distX ) / maxDist ) * 10
            p.r = if radius > 10 then 10 else radius
          else
            p.r = 2

          distY = Math.abs p.pos.y - m.y
          if distY < maxDist
            radius = 2 + ( ( maxDist - distY ) / maxDist ) * 3
            p.r += if radius > 3 then 3 else radius
          else
            p.r = 2


          # p.r = 2 + dx.mag()*101

          # force = m.clone().mult(.0008)
          # @mag = o.mouse.clone().subs(@pos).mag()
            # @vel.add o.mouse.clone()

          p.vel.add force
          p.vel.add new Vec 0,0.01
          # p.pos = o?.mouse
          p.pos.add p.vel
          # if p.pos.x >

      sketch.draw = ->
        l = particles.length
        for p,i in particles
          x = i*@width/l + @width/l/2

          @fillStyle = 'rgba(255,255,255,0.05)'
          @strokeStyle = "rgba(255,255,255,#{p.m/15})"
          @lineWidth = p.m/100
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
          @fillStyle = "hsla(150, 100%, 65%, #{p.m*p.r/200})"
          @beginPath()
          @arc( x, p.pos.y, 1+p.r/5, 0, TWO_PI )
          @fill()

          # @beginPath()
          # @arc( p.pos.x, p.pos.y, p.r, 0, TWO_PI )
          # @fillStyle = 'rgba(255,255,255,0.1)'
          # @fill()

          # @fillStyle = "hsla(150, 100%, 65%, #{p.m/200})"
          grd = @createRadialGradient(x, p.pos.y, 1, x, p.pos.y, 120)
          grd.addColorStop(0, "hsla(150, 100%, 65%, #{p.m/150})")
          grd.addColorStop(0.9, "transparent")
          @fillStyle = grd
          @beginPath()
          @ellipse(x, p.pos.y, p.r/3, 1+p.r*5, 0, 0, 2 * Math.PI)
          @fill()

  }
</script>

<style lang="stylus">
  .landing
    position: relative
    min-height: 100vh
    color: c0

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
    pointer-events: none
    width: 100%
    min-height: 100vh
    display: flex
    align-items: center
    justify-content: center
    font-family: 'Amatic SC', cursive
    font-family: 'Caveat', cursive
    font-family: 'Neucha', cursive
    font-family: 'Fira Code', monospace
    .text
      pointer-events: all
      color: #fff
      font-size: 2.3rem
      font-weight: 100
      line-height: 3rem
      // letter-spacing: 1px
      .highlight
        font-weight: 800
        color: c8
        white-space: nowrap
</style>
