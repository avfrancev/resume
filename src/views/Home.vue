<template lang="pug">
  .home
    Landing
    .routes
      nav
        a(
          v-for="r in routes"
        ) {{r.nameStartCase}}
        a A front-end development engineer who loves UI effects, animation, and dynamic user experience.
    p.aaa Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatum consequatur beatae sunt eaque exercitationem, dicta, harum nisi quas maiores eum nihil vel neque eveniet doloribus ut natus tenetur voluptas itaque!
    p Lorem i sit amet consectetur adipisicing elit. Excepturi perferendis cum tenetur. Quia cupiditate consectetur perferendis eius dolorum corporis hic illo, vitae enim totam tenetur laudantium obcaecati mollitia magni in!
</template>

<script lang="coffee">

  import { TweenMax } from 'gsap'

  export default {
    name: 'home',
    components:
      Landing: require('@/views/home/Landing.vue').default

    computed:
      routes: ->
        @$router.options.routes.map (r) ->
          r.nameStartCase = _.startCase r.name
          r
    created: ->


    # created: ->
    #   console.time('qwe')
    #   console.log '------'
    #   # a = await fetch'https://api.github.com/repos/avfrancev/liquid-cards/commits'
    #   # a = await a.json()
    #   # console.log a
    #   # req = await fetch 'https://api.github.com/users/avfrancev/repos'
    #   repos = await (await fetch 'https://api.github.com/users/avfrancev/repos').json()
    #   # repos = await req.json()
    #   urls = repos.map (x) ->
    #     x.commits_url[0..-7]
    #   commits = []
    #   for url in urls
    #     console.log url
    #     req = await fetch url
    #     json = await req.json()
    #     commits.push await json
    #     console.log json.map (x) -> {message: x.commit.message, date: x.commit.author.date}
    #   console.log '------'
    #   console.timeEnd('qwe')

  }
</script>


<style lang="stylus">
  @import url('https://fonts.googleapis.com/css?family=Fira+Code:300,400,700&display=swap&subset=cyrillic')
  body
    background-color: c1
  p.aaa
    padding-top: 10vr
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
      padding: 12px 15px
      &:hover
        background: rgba(#fff,0.1)

</style>
