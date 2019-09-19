<template lang="pug">
  .home
    Landing
    //- .landing(
      @mousemove="mousemove"
      )
      svg.canvas
        defs
          //- <filter id="goo">
          //-   <feGaussianBlur in="SourceGraphic" stdDeviation="10" result="blur" />
          //-   <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="goo" />
          //-   <feBlend in="SourceGraphic" in2="goo" />
          //- </filter>
          <filter id="fancy-goo">
            <feGaussianBlur in="SourceGraphic" stdDeviation="5" result="blur" />
            <feColorMatrix in="blur" type="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 14 -4" result="goo" />
            <feComposite in="SourceGraphic" in2="goo" operator="atop"/>
          </filter>
          //- :cx="p.pos.x + width/2"
          //- :cy="p.pos.y + height/2"
        path(
          d="m 100,100 H 500"
          stroke="red"
          stroke-width="10"
          filter="url(#fancy-goo)"
        )
        g(
          v-for="p in particles"
          )
          circle(
            r="5"
            fill="red"
            ref="circle"
            )
        //- g(
          v-for="p,i in particles"
          )
          line(
            :x1="0"
            :y1="0"
            :x2="0"
            :y2="height"
            stroke="#333"
            stroke-width="1"
            :stroke-dasharray="`101 10`"
            :transform="`translate(${p.pos_.x},${p.pos_.y})`"
            )
          line(
            :x1="0"
            :y1="-height"
            :x2="0"
            :y2="0"
            stroke="#333"
            stroke-width="1"
            :stroke-dasharray="`101 10`"
            :transform="`translate(${p.pos_.x},${p.pos_.y})`"
            )
          //- line(
          //-   :x1="`${(i+0.5)*100/particles.length}%`"
          //-   y1="0%"
          //-   :x2="`${(i+0.5)*100/particles.length}%`"
          //-   :y2="p.pos.y + height/2"
          //-   stroke="#333"
          //-   :stroke-dasharray="` ${(p.pos.y + height/2)/10} 10`"
          //-   stroke-width="1"
          //-   )
          //-   //- :stroke-dasharray="` ${(p.pos.y + height/2)/5} 10`"
          //- line(
          //-   :x1="`${(i+0.5)*100/particles.length}%`"
          //-   :x2="`${(i+0.5)*100/particles.length}%`"
          //-   y1="100%"
          //-   :y2="p.pos.y + height/2"
          //-   stroke="#333"
          //-   :stroke-dasharray="` ${(( height - p.pos.y))/10} 10`"
          //-   )
          circle(
            :cx="`${(i+0.5)*100/particles.length}%`"
            :r="1"
            :transform="`translate(0,${p.pos.y + height/2}) scale(1,${(p.vel.y+1)*height/(10*particles.length)})`"
            fill="rgba(195, 36, 102,0.3)"
            )
          //- circle(
            :cx="p.pos_.x"
            :transform="`translate(0,${p.pos_.y})`"
            :r="11"
            fill="rgba(195, 36, 102,0.7)"
            )
          //- circle(
            :transform="`translate(${p.pos.x + width/2},${p.pos.y + height/2})`"
            :r="2+(500/p.mag)"
            fill="red"
            )

      .intro
        .text Hello, I'm
          span.highlight  Alex Francev
          |,
          br
          | a full-stack web developer.
    .routes
      nav
        a(
          v-for="r in routes"
        ) {{r.nameStartCase}}
        a A front-end development engineer who loves UI effects, animation, and dynamic user experience.
    p Lorem i sit amet consectetur adipisicing elit. Excepturi perferendis cum tenetur. Quia cupiditate consectetur perferendis eius dolorum corporis hic illo, vitae enim totam tenetur laudantium obcaecati mollitia magni in!
</template>

<script lang="coffee">

  import { TweenMax } from 'gsap'
  import {Particle, Vec} from '@/libs/Particles.coffee'

  export default {
    name: 'home',
    components:
      Landing: require('@/components/Landing.vue').default
    data: ->
      particles: []
      particles_: []
      mouse: new Vec
      height: 0
      width: 0

    created: ->
      window.addEventListener 'resize', =>
        console.log BBox = @$el.getBoundingClientRect()
        @width = BBox.width
        @height = BBox.height
        return
    mounted: ->
      BBox = @$el.getBoundingClientRect()
      @width = BBox.width
      @height = BBox.height
      @particles = [0...10].map ->
        new Particle
          pos: new Vec _.random(-200,200), _.random(-200,200)
          r: _.random 10,20
          mag: 1
      console.log @particles_ = @particles.map (p) -> {
        pos: p.pos
        vel: p.vel
        mag: p.mag
        r: p.r
      }
      # @$nextTick @particlesTick
      # @particlesTick()

    computed:
      routes: ->
        @$router.options.routes.map (r) ->
          r.nameStartCase = _.startCase r.name
          r
    methods:
      click: (e) ->
        # pos = new Vec e.offsetX,e.offsetY
        pos = new Vec e.clientX,e.clientY
        pos.subs(new Vec @width/2,@height/2)
        amount = _.random 5,10
        for i in [0...amount]
          p = new Particle
            pos: new Vec _.random(pos.x-10,pos.x+10), _.random(pos.y-10,pos.y+10)
            # pos: pos
            vel: new Vec _.random(-10,10),_.random(-10,10)
            # force: new Vec _.random(-100,100),_.random(-10,10)
            r: _.random 5,30
          @particles.push p
          @particles_.push _.pick p, ['pos','color','r']
          if @particles.length > 100
            @particles.splice(0, @particles.length - 100)
            [].splice.call @particles_, 0, @particles.length - 100
            # @particles_.splice(0, @particles.length - 100)

      mousemove: (e) ->
        @mouse = new Vec e.offsetX,e.offsetY
        @mouse.subs(new Vec @width/2,@height/2)
      particlesTick: ->
        for p,i in @particles
          p.force = new Vec _.random(-10,10),new Vec _.random(-10,10)
          p.vel.add p.force
          p.vel.mult 0.97
          p.pos.add p.vel
          TweenMax.to @$refs.circle[i], 1,
            x: p.pos.x + @width/2
            y: p.pos.y + @height/4
            ease:  Power0.easeNone
        # console.log @$refs.circle


        # for p,i in @particles
        #   p.update({
        #     mouse:@mouse
        #   })
        #   p.pos_ =
        #     x: i*@width/@particles.length + @width/@particles.length/2
        #     y: p.pos.y + @height/2

        # console.log @particles
        # setTimeout @particlesTick, 800
        # window.requestAnimationFrame @particlesTick
  }
</script>


<style lang="stylus">
  @import url('https://fonts.googleapis.com/css?family=Amatic+SC&display=swap')
  // @import url('https://fonts.googleapis.com/css?family=Caveat|Neucha|Fira+Code&display=swap')
  @import url('https://fonts.googleapis.com/css?family=Fira+Code:300,400,700&display=swap&subset=cyrillic')
  body
    /* min-height: 100vh */
    // min-height: 100vh
    /* background: #34295A */
    background-color: c1
    /* background-image: -webkit-radial-gradient(top, circle cover, #3c3b52 0%, #252233 80%), url("https://www.transparenttextures.com/patterns/asfalt-dark.png") */
    /* background-image: url("https://www.transparenttextures.com/patterns/black-twill.png"), -webkit-radial-gradient(top, circle cover, #3c3b52 0%, #252233 80%) */
    /* background-image: url("https://www.transparenttextures.com/patterns/brilliant.png"), -webkit-radial-gradient(top, circle cover, #3c3b52 0%, #252233 80%) */
    background-image: url("https://www.transparenttextures.com/patterns/classy-fabric.png"),
      -webkit-radial-gradient(top, circle cover, c1 0%, darken(c1,40%) 80%)
    background-repeat: repeat, no-repeat
    background-size: auto, 100% 100%

  .routes
    background: c6
    display: flex
    align-items: center
    justify-content: center
    min-height: 100vh
    nav
      display: flex
      flex-direction: column
    a
      font-size: 1.2rem
      font-weight: 800
      text-decoration: none
      color: #fff
      // width: 100%
      padding: 12px 15px
      &:hover
        background: rgba(#fff,0.1)

</style>
