<template>
  <div class="main-header">
    <!-- メインヘッダー -->
    <v-container>
      <v-row>
        <v-col class="mb-6"><img src="../packs/assets/logo.png"/></v-col>
        <v-col class="mb-6">aagggaa</v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  mounted() {
    this.$store.dispatch("page/setType", "top")
  }
}
</script>

<style scoped>
.main-header {
  background-color: #fff;
}
</style>
