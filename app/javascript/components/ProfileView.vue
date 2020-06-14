<template>
  <div>
    <v-list-item>
      <v-list-item-avatar color="grey" size="60">
        <v-img :src="user.avatarUrl" />
      </v-list-item-avatar>
      <v-list-item-content>
        <v-list-item-title class="title">
          {{ user.name }}
        </v-list-item-title>
        <v-list-item-subtitle
          >@{{ user.screenName }}
          <v-btn icon color="blue" :href="twitterUrl">
            <v-icon>mdi-twitter</v-icon>
          </v-btn>
        </v-list-item-subtitle>
      </v-list-item-content>
    </v-list-item>
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
        >ユーザーページを見る</v-btn
      >
      <v-btn
        depressed
        color="primary"
        class="ma-2"
        href="/admin"
        v-if="user.role === '管理ユーザー'"
        >管理ページ</v-btn
      >
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
