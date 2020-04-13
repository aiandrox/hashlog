<template>
  <div class="page1">
    <h1>{{ msg }}</h1>
    <div class="message">
      <p class="page1_message_inner">これはページ1です。</p>
      <br />ここが他のページに入れ替わります。
      <br />この中はふつーのHTMLで記載できます。
      <br />スタイルシートのスコープなんてきにしなくてへいき。
      <br />
    </div>
    <router-link to="/mypage">マイページ</router-link>
  </div>
</template>

<script>
export default {
  name: "global_footer",
  props: {
    msg: "ページ1"
  },
  methods: {
    testAJAX(id) {
      axios.get(`api/books/${id}.json`).then(res => {
        this.bookInfo = res.data;
        this.bookInfoBool = true;
      });
    }
  }
};
</script>

<style scoped lang="scss">
.page1 {
  .message {
    margin: 1em;
    padding: 1em;
    background: #efefef;
    border: solid darkblue;
  }
}

$color-red1: #730e15;
.page1 {
  &_message {
    &_inner {
      color: $color-red1;
    }
  }
}
</style>