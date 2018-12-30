<template>
  <div id="app">
    <blog-header/>
    <router-view/>
    <blog-footer/>
  </div>
</template>

<script>
import BlogHeader from '@/components/BlogHeader'
import BlogFooter from '@/components/BlogFooter'

export default {
  name: 'App',
  components: {
    BlogHeader,
    BlogFooter
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
