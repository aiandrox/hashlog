<template>
  <v-card flat>
    <!-- ビュー部分 -->
    <status-view :registeredTag="registeredTag" v-show="!isEditing" />
    <!-- 編集部分 -->
    <status-edit :registeredTag="registeredTag" v-show="isEditing" />
    <v-btn class="ma-2" outlined @click="isEditing = true" v-show="!isEditing">
      <v-icon left>mdi-cog</v-icon>設定
    </v-btn>
    <div v-show="isEditing">
      <v-btn class="ma-2" outlined @click="isEditing = false">
        <v-icon left>mdi-content-save</v-icon>保存
      </v-btn>
      <v-btn class="ma-2" outlined @click="isEditing = false">キャンセル</v-btn>
      <v-btn class="ma-2" outlined color="error" @click="pushDelete">
        <v-icon left>mdi-delete</v-icon>ハッシュタグを削除
      </v-btn>
    </div>
  </v-card>
</template>

<script>
import statusView from "./TagStatusView"
import statusEdit from "./TagStatusEdit"
export default {
  components: {
    statusView,
    statusEdit
  },
  props: {
    registeredTag: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      isEditing: false
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
