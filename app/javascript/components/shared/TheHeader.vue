<template>
  <v-app-bar app flat dark color="#006596">
    <v-toolbar-title color="#f0faff">Hashlog</v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <v-btn text href="/api/v1/oauth/twitter">ログイン</v-btn>
      <v-btn text :to="{ name: 'mypage' }">マイページ</v-btn>
      <v-btn text :to="{ name: 'user', params: { userUuid: 'HTagphtz9-sM' } }">ユーザーページ</v-btn>
      <v-btn text @click="logout">ログアウト</v-btn>
    </v-toolbar-items>
  </v-app-bar>
</template>

<script>
export default {
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
