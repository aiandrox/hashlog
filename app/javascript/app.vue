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
import Header from "./packs/components/shared/header.vue";
import Footer from "./packs/components/shared/footer.vue";
import FlashMessage from "./packs/components/shared/flash-message.vue";

export default {
  name: "MyApp",
  props: {
    msg: String
  },
  components: {
    Header,
    Footer,
    FlashMessage
  }
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>
