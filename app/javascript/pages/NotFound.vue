<template>
  <div class="content pt-10 pb-5">
    <h1 class="display-3 font-weight-thin">404 NotFound</h1>
    <div class="mt-10 mb-10">
      <p>お探しのページが見つかりませんでした。</p>
      <p>
        一時的にアクセスができない状況にあるか
        <br class="d-none d-sm-flex" />移動もしくは削除された可能性があります。
      </p>
      <p>URLにお間違いがないか再度ご確認ください。</p>
    </div>
    <v-btn color="primary" depressed :to="{ name: 'top' }">
      <v-icon left>mdi-exit-run</v-icon>トップページに戻る
    </v-btn>
  </div>
</template>

<script>
export default {
  mounted() {
    document.title = "ページが見つかりません | Hashlog"
  }
}
</script>

<style scoped>
.content {
  margin: 0 auto;
  max-width: 400px;
}
</style>
