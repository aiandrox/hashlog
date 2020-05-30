<template>
  <v-app-bar app flat dark color="#006596">
    <v-toolbar-title color="#f0faff">Hashlog</v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <v-btn text v-if="!currentUser" href="/api/v1/oauth/twitter">ログイン</v-btn>
      <v-btn text v-if="currentUser" :to="{ name: 'mypage' }">マイページ</v-btn>
      <v-btn text v-if="currentUser" @click="logout">ログアウト</v-btn>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex"

export default {
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" })
  },
  methods: {
    logout() {
      try {
        this.$axios.delete("/api/v1/logout", {})
        this.$router.push({ name: "top" })
      } catch (error) {
        console.log(error)
      }
    }
  }
}
</script>
