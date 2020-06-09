<template>
  <v-container>
    <v-list-item v-for="status in statusArray" :key="status.name">
      <v-list-item-content>
        <v-list-item-subtitle>{{ status.title }}</v-list-item-subtitle>
        <v-list-item-title>{{ status.text }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-container>
</template>

<script>
export default {
  props: {
    registeredTag: {
      type: Object,
      default: () => {},
      required: true
    }
  },
  computed: {
    statusArray() {
      return [
        {
          name: "name",
          title: "ハッシュタグ",
          text: `#${this.registeredTag.tag.name}`
        },
        {
          name: "privacy",
          title: "公開設定",
          text: this.registeredTag.privacy
        },
        {
          name: "tweetedDayCount",
          title: "ツイート総日数",
          text: `${this.registeredTag.tweetedDayCount}日（${this.registeredTag.tweetRate}%）`
        },
        {
          name: "firstTweetedAt",
          title: "初めてのツイート",
          text: this.date(this.registeredTag.firstTweetedAt)
        },
        {
          name: "lastTweetedAt",
          title: "最新のツイート",
          text: this.date(this.registeredTag.lastTweetedAt)
        }
      ]
    }
  },
  methods: {
    date(date) {
      if (date === null) {
        return "まだツイートはありません"
      }
      return this.$fullDateFormat(date)
    }
  }
}
</script>
