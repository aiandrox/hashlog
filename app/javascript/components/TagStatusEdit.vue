<template>
  <v-list v-show="isEditing">
    <v-list-item class="pb-0">
      <v-list-item-content class="pb-0">
        <v-list-item-subtitle>ハッシュタグ</v-list-item-subtitle>
        <v-list-item-title>#{{ registeredTag.tag.name }}</v-list-item-title>
      </v-list-item-content>
    </v-list-item>
    <v-list-item>
      <v-list-item-content class="pt-0">
        <v-form v-model="valid" class="pt-0">
          <v-select
            v-model="select"
            :items="items"
            :rules="[v => !!v || 'Item is required']"
            required
          ></v-select>
          <v-container>
            <v-checkbox v-model="isRemind">
              <template v-slot:label>
                <div @click.stop>リマインダーを使用する</div>
              </template>
            </v-checkbox>
          </v-container>
          <v-text-field
            v-show="isRemind"
            v-model="firstname"
            label="リマインダー"
            hint="設定した日数ツイートがない場合、Hashlogアカウントからリプライが送られます。"
            persistent-hint
            suffix="日"
          />
        </v-form>
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
    isRemind() {
      if (this.registeredTag.remindDay === 0) {
        return false
      }
      return true
    },
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
