<template>
  <div id="app">
    <Header />>
    <router-view />
    <Footer />
  </div>
</template>

<script>
import Header from "./packs/components/shared/header.vue";
import Footer from "./packs/components/shared/footer.vue";

export default {
  name: "MyApp",
  props: {
    msg: String
  },
  components: {
    Header,
    Footer
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
