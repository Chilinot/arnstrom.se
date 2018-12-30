import Vue from 'vue'
import Router from 'vue-router'
import PageNotFound from '@/components/PageNotFound'
import Index from '@/components/Index'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '*',
      name: '404',
      component: PageNotFound
    },
    {
      path: '/',
      name: 'Index',
      component: Index
    }
  ]
})
