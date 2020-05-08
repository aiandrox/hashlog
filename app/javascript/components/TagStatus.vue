<template>
  <v-card flat>
    <v-list disabled>
      <v-list-item-group color="primary">
        <v-list-item v-for="status in statusArray" :key="status.name">
          <v-list-item-content>
            <v-list-item-subtitle>{{ status.title }}</v-list-item-subtitle>
            <v-list-item-title>{{ status.text }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
    <v-btn class="ma-2" outlined @click="pushDelete">
      <v-icon left>mdi-delete</v-icon>削除
    </v-btn>
    <v-btn class="ma-2" outlined> <v-icon left>mdi-cog</v-icon>設定 </v-btn>
  </v-card>
</template>

<script>
export default {
  props: {
    registeredTag: {
      type: Object,
      default: () => {}
    }
  },
  methods: {
    pushDelete() {
      this.$emit("push-delete")
    },
    date(date) {
      if (date === null) {
        return "まだツイートはありません"
      }
      return this.dayjs(date)
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
          name: "privacy",
          title: "公開設定",
          text: this.registeredTag.privacy
        },
        {
          name: "remindDay",
          title: "リマインダー",
          text: this.registeredTag.remindDay
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
  }
}
</script>
