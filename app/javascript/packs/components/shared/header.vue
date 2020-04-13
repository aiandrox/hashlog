<template>
  <v-app-bar app flat>
    <v-card class="d-flex mb-6" color="grey lighten-2" flat tile>
      <v-toolbar-title>Hashlog</v-toolbar-title>
      <v-card class="pa-2" outlined tile>
        <router-link to="/mypage">Twitterログイン</router-link>
      </v-card>
      <v-card class="pa-2" outlined tile>
        <router-link to="/">トップページ</router-link>
      </v-card>
    </v-card>
  </v-app-bar>
</template>

<script>
export default {
  name: "global_header",
  props: {
    msg: String
  }
};
</script>

<style scoped>
</style>