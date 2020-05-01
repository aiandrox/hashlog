<template>
  <div id="app">
    <v-app>
      <Header />
      <v-content>
        <v-container>
          <flash-message />
          <router-view />
        </v-container>
      </v-content>
      <Footer />
    </v-app>
  </div>
</template>

<script>
import Header from "./components/shared/TheHeader.vue"
import Footer from "./components/shared/TheFooter.vue"
import FlashMessage from "./components/shared/TheFlashMessage.vue"

export default {
  name: "MyApp",
  components: {
    Header,
    Footer,
    FlashMessage
  }
}
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>
