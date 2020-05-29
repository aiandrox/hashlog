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
.v-application--wrap {
  background-color: #e9f1f5;
}
</style>
