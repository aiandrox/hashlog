<template>
  <v-app-bar app flat dark color="#006596">
    <v-toolbar-title v-if="pageType !== 'top'" color="#f0faff"
      >Hashlog</v-toolbar-title
    >
    <v-spacer />
    <v-toolbar-items>
      <v-btn v-if="!currentUser" text href="/api/v1/oauth/twitter"
        >ログイン</v-btn
      >
      <v-btn v-if="currentUser" text :to="{ name: 'mypage' }">マイページ</v-btn>
      <v-btn v-if="currentUser" text @click="logout">ログアウト</v-btn>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex"

export default {
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" }),
    ...mapGetters({ pageType: "page/type" })
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
