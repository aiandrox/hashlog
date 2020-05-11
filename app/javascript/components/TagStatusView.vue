<template>
  <v-list disabled>
    <v-list-item v-for="status in statusArray" :key="status.name">
      <v-list-item-content>
        <v-list-item-subtitle>{{ status.title }}</v-list-item-subtitle>
        <v-list-item-title>{{ status.text }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
  </v-list>
</template>

<script>
export default {
  props: {
    registeredTag: {
      type: Object,
      default: () => {}
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
          name: "tweetedDayCount",
          title: "ツイート総日数",
          text: `${this.registeredTag.tweetedDayCount}日`
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
      return this.dayjs(date)
    }
  }
}
</script>
