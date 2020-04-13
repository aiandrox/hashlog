<template>
  <div id="app">
    <v-app>
      <Header />
      <flash-message />
      <v-content>
        <v-container>
          <router-view />
        </v-container>
      </v-content>
      <v-footer app>
        <Footer />
      </v-footer>
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
  margin-top: 60px;
}
</style>
