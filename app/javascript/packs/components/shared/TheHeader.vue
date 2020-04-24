<template>
  <v-app-bar
    app
    flat
    dark
    src="https://cdn.vuetifyjs.com/images/backgrounds/vbanner.jpg"
  >
    <v-toolbar-title>Hashlog</v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <v-btn text href="api/v1/oauth/twitter">ログイン</v-btn>
      <v-btn text to="/mypage">マイページ</v-btn>
      <v-btn text @click="logout">ログアウト</v-btn>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
import Axios from "axios"
export default {
  methods: {
    logout() {
      Axios.delete("/api/v1/logout", {}).then(response => {
        this.$router.push({ path: "/" })
      })
    }
  }
}
</script>
