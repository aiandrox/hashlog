<template>
  <div id="app">
    <v-app>
      <the-header />
      <v-main>
        <v-container v-if="!isTopPage">
          <the-flash-message v-if="isFlash" />
          <the-not-found v-if="isNotFound" />
          <router-view v-else />
        </v-container>
        <router-view v-if="isTopPage" />
      </v-main>
      <the-footer />
    </v-app>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import theHeader from "./components/shared/TheHeader"
import theFooter from "./components/shared/TheFooter"
import theFlashMessage from "./components/shared/TheFlashMessage"
import theNotFound from "./pages/NotFound"

export default {
  name: "MyApp",
  components: {
    theHeader,
    theFooter,
    theFlashMessage,
    theNotFound
  },
  computed: {
    ...mapGetters({
      isFlash: "flash/isFlash",
      isNotFound: "isNotFound/isNotFound"
    }),
    isTopPage() {
      return this.$route.path === "/"
    }
  },
  watch: {
    $route() {
      this.$store.dispatch("isNotFound/setIsNotFound", {
        boolean: false
      })
    }
  }
}
</script>

<style>
.v-application--wrap {
  background-color: #e9f1f5;
}
.container.main-content {
  max-width: 900px;
  margin: 0 auto;
}
.main-content {
  max-width: 900px;
  margin: 0 auto;
}
</style>
