<template>
  <v-app-bar app>
    <v-toolbar-title>Hashlog</v-toolbar-title>
    <router-link to="/mypage">Twitterログイン</router-link>
    <div>ゲストユーザーとしてログイン</div>
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
#header {
  background: aliceblue;
}
</style>