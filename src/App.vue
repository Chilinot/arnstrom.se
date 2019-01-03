<template>
  <div id="app">
    <BlogHeader/>

    <div class="container">
      <router-view/>
    </div>

    <BlogFooter/>
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
@import "https://fonts.googleapis.com/css?family=Open+Sans|Thasadith";

#app {
  font-family: 'Open Sans';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

.container {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.row {
  flex-flow: row wrap;
}
</style>
