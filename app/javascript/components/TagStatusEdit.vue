<template>
  <ValidationObserver ref="observer" v-slot="{ invalid }">
    <v-container>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-subtitle>ハッシュタグ</v-list-item-subtitle>
          <v-list-item-title>#{{ tag.name }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item>
        <v-form class="pt-0">
          <v-select
            :value="privacy"
            :items="privacyChoices"
            prepend-icon="mdi-earth"
            required
            @input="$emit('update:privacy', $event)"
          />
          <v-checkbox
            v-model="isRemind"
            class="mt-0"
            messages="設定した日数ツイートがない場合、公式アカウントよりメンションが送られます"
            label="リマインダーを使用する"
          />
          <validation-provider
            v-slot="{ errors }"
            :rules="
              `${isRemind ? 'remindDayFormat|maxRemindDay|minRemindDay' : ''}`
            "
          >
            <v-text-field
              v-show="isRemind"
              :value="remindDay"
              :error-messages="errors"
              placeholder="リマインダー"
              suffix="日"
              hint="1〜30日で設定できます"
              persistent-hint
            />
    </v-container>
    <v-list-item>
      <v-btn class="ma-2" outlined color="primary" @click="$emit('push-cancel')">キャンセル</v-btn>
      <v-btn
        class="ma-2"
        depressed
        dark
        color="depressedButton"
        :disabled="invalid"
        @click="pushUpdate"
      >
        <v-icon left>mdi-checkbox-marked-outline</v-icon>保存
      </v-btn>
    </v-list-item>
    <v-list-item justify="center">
      <v-btn class="ma-2" outlined color="error" @click="$emit('push-delete')">
        <v-icon left>mdi-delete</v-icon>ハッシュタグを削除
      </v-btn>
    </v-list-item>
  </ValidationObserver>
</template>

<script>
export default {
  props: {
    privacy: {
      type: String,
      default: "非公開",
      required: true
    },
    remindDay: {
      type: [Number, String],
      default: 0,
      require: true
    },
    tag: {
      type: Object,
      default: () => {},
      required: true
    }
  },
  data() {
    return {
      privacyChoices: ["公開", "限定公開", "非公開"],
      isRemind: true,
    }
  },
  methods: {
    fetchSelectFromRemindDay() {
      if (!!this.remindDay === false) {
        this.isRemind = false
      } else {
        this.isRemind = true
      }
    },
    fetchRemindDayFromForm() {
      this.$emit("update:remindDay", this.filter(this.remindDay))
      if (this.isRemind === false) {
        this.$emit("update:remindDay", 0)
      }
    },
    // TODO: vee-validate.jsと同じメソッドになっている
    filter(remindDay) {
      if (remindDay === null) {
        return 0
      }
      const stringRemindDay = String(remindDay)
      const deleteDayResult = stringRemindDay.split("日").join("")
      // 全角数字を半角に変換
      const result = deleteDayResult.replace(/[０-９]/g, s =>
        String.fromCharCode(s.charCodeAt(0) - 65248)
      )
      // result => "20", "文字列"
      const number = Number(result) < 0 ? 0 : Number(result)
      return number
    },
    pushUpdate() {
      this.fetchRemindDayFromForm()
      this.$emit("push-update")
    },
    // バケツリレー用
    inputPrivacy(v) {
      this.$emit("input-privacy", v)
    },
    inputRemindDay(v) {
      this.$emit("input-remind-day", v)
    },
  },
}
</script>
