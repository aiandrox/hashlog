<template>
  <div>
    <v-card-text>
      <div
        class="body-1"
        style="white-space: pre-line;word-wrap: break-word"
        v-html="$sanitize(replacedDescription)"
      />
    </v-card-text>
    <div v-if="isMypage">
      <v-btn class="ma-2" outlined color="primary" @click="$emit('push-edit')">
        <v-icon left>mdi-pencil</v-icon>編集
      </v-btn>
      <v-btn
        outlined
        color="primary"
        class="ma-2"
        :to="{ name: 'user', params: { userUuid: user.uuid } }"
      >ユーザーページを見る</v-btn>
      <v-btn
        v-if="user.role === '管理ユーザー'"
        depressed
        color="primary"
        class="ma-2"
        href="/admin"
      >管理ページ</v-btn>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: () => {},
      required: true
    }
  },
  computed: {
    twitterUrl() {
      return `https://twitter.com/${this.user.screenName}`
    },
    replacedDescription() {
      const replaced = this.user.description.replace(
        /(https?:\/\/[\w!-/:-@¥[-`{-~]*)/g,
        "<a href='$1' target='_blank'>$1</a>"
      )
      return replaced
    },
    isMypage() {
      return this.$route.path.includes("/mypage/")
    }
  }
}
</script>
