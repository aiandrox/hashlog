<template>
  <div>
    <v-btn text href="/api/v1/oauth/twitter">ログイン</v-btn>
    <v-btn text :to="{ name: 'mypage' }">マイページ</v-btn>
    <v-btn text :to="{ name: 'user', params: { userUuid: 'HTagphtz9-sM' } }">ユーザーページ</v-btn>
    <v-btn text>ログアウト</v-btn>
  </div>
</template>

<script>
export default {
  data: () => ({
    name: "",
    email: "",
    select: null,
    items: ["Item 1", "Item 2", "Item 3", "Item 4"],
    checkbox: null
  }),
  mounted() {
    this.$store.dispatch("page/setType", "top")
  },
  methods: {
    submit() {
      this.$refs.observer.validate()
    },
    clear() {
      this.name = ""
      this.email = ""
      this.select = null
      this.checkbox = null
      this.$refs.observer.reset()
    }
  }
}
</script>
