<template>
  <header>
    <router-link :to="{ name: 'top' }">top</router-link>|
    <router-link :to="{ name: 'mypage'} ">マイページ</router-link>
    <nav>
      <ul>
        <li>Twitterログイン</li>
        <li>ゲストユーザーとしてログイン</li>
      </ul>
    </nav>
  </header>
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