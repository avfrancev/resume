import _ from 'lodash'
import Vue from 'vue'
import Router from 'vue-router'

#
# Lazy load routes
# https://webpack.js.org/guides/dependency-management/
#

req = require.context('./views/', false, /\.vue$/, 'lazy')
routes = req.keys().map (_path) ->
	name = _.snakeCase(_path)[..-5]
	path = '/'
	path += if name is 'home' then '' else name
	{
		path
		name
		component: () => import(### webpackChunkName: "view-[request]" ### "@/views/#{_path[2..]}")
	}

Vue.use Router

export default new Router({
	mode: 'history'
	base: process.env.BASE_URL
	routes
})
