<template>
  <ValidationObserver ref="observer" v-slot="{ invalid }">
    <v-list>
      <v-list-item class="pb-0">
        <v-list-item-content class="pb-0">
          <v-list-item-subtitle>ハッシュタグ</v-list-item-subtitle>
          <v-list-item-title>#{{ registeredTag.tag.name }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item>
        <v-list-item-content class="pt-0">
          <v-form class="pt-0">
            <v-select
              v-model="registeredTag.privacy"
              :items="privacyChoices"
              prepend-icon="mdi-earth"
              required
            />
            <v-container>
              <v-checkbox
                v-model="isRemind"
                class="mt-0"
                messages="設定した日数ツイートがない場合、公式アカウントよりリプライが送られます"
                label="リマインダーを使用する"
              />
              <validation-provider
                v-slot="{ errors }"
                rules="remindDay|maxRemindDay"
              >
                <v-text-field
                  v-show="isRemind"
                  v-model="registeredTag.remindDay"
                  :error-messages="errors"
                  placeholder="リマインダー"
                  suffix="日"
                  hint="1〜30日で設定できます"
                  persistent-hint
                />
              </validation-provider>
            </v-container>
          </v-form>
        </v-list-item-content>
      </v-list-item>
    </v-list>
    <v-btn class="ma-2" outlined @click="pushCancel">キャンセル</v-btn>
    <v-btn class="ma-2" outlined @click="pushUpdate" :disabled="invalid">
      <v-icon left>mdi-content-save</v-icon>保存
    </v-btn>
    <v-btn class="ma-2" outlined color="error" @click="pushDelete">
      <v-icon left>mdi-delete</v-icon>ハッシュタグを削除
    </v-btn>
  </ValidationObserver>
</template>

<script>
export default {
  props: {
    registeredTag: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      privacyChoices: ["公開", "限定公開", "非公開"],
      isRemind: true
    }
  },
  methods: {
    fetchSelectFromRemindDay() {
      if (!!this.registeredTag.remindDay === false) {
        this.isRemind = false
      } else {
        this.isRemind = true
      }
    },
    fetchRemindDayFromForm() {
      this.registeredTag.remindDay = this.filter(this.registeredTag.remindDay)
      if (this.isRemind === false) {
        this.registeredTag.remindDay = 0
      }
    },
    // TODO: vee-validate.jsと同じメソッド
    filter(remindDay) {
      const stringRemindDay = String(remindDay)
      if (stringRemindDay === null) {
        return 0
      }
      const deleteDayResult = stringRemindDay.split("日").join("")
      const result = deleteDayResult.replace(/[０-９]/g, s =>
        String.fromCharCode(s.charCodeAt(0) - 65248)
      )
      // result => "20", "文字列"
      const number = Number(result) < 0 ? 0 : Number(result)
      return number
    },
    pushDelete() {
      this.$emit("push-delete")
    },
    pushUpdate() {
      this.fetchRemindDayFromForm()
      this.$emit("push-update")
    },
    pushCancel() {
      this.$emit("push-cancel")
    }
  }
}
</script>
