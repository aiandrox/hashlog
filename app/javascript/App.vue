<template>
  <div id="app">
    <v-app>
      <the-header />
      <v-content>
        <v-container>
          <!-- <flash-message /> -->
          <router-view />
        </v-container>
      </v-content>
      <the-footer />
    </v-app>
  </div>
</template>

<script>
import theHeader from "./components/shared/TheHeader.vue"
import theFooter from "./components/shared/TheFooter.vue"
// import FlashMessage from "./components/shared/TheFlashMessage.vue"

export default {
  name: "MyApp",
  components: {
    theHeader,
    theFooter
    // FlashMessage
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
