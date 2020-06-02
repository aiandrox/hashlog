<template>
  <v-fade-transition v-if="isShow">
    <div class="flash">
      <v-alert dense outlined type="success">更新しました</v-alert>
      <v-alert dense outlined type="error">エラーが発生しました</v-alert>
    </div>
  </v-fade-transition>
</template>

<script>
export default {
  data() {
    return {
      isShow: true,
      message: "flash message"
    }
  },
  mounted() {
    setTimeout(() => {
      this.isShow = false
    }, 4000)
  }
}
</script>

<style scoped>
.flash {
  position: fixed;
  bottom: 10px;
  left: 20px;
  width: 250px;
  z-index: 5;
  /* フッターがz-index: 3なので */
}
.v-alert--outlined {
  background: rgba(255, 255, 255, 0.9) !important;
}
</style>
