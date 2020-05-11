<template>
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
              messages="設定した日数ツイートがない場合、公式アカウントよりリプライが送られます。"
              label="リマインダーを使用する"
            />
            <v-text-field
              v-show="isRemind"
              v-model.number="registeredTag.remindDay"
              placeholder="リマインダー"
              suffix="日"
              hint="半角数字 1〜30日"
              persistent-hint
            />
          </v-container>
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
  data() {
    return {
      privacyChoices: ["公開", "限定公開", "非公開"],
      isRemind: true
    }
  },
  methods: {
    checkReminder() {
      if (!!this.registeredTag.remindDay === false) {
        this.isRemind = false
      } else {
        this.isRemind = true
      }
    }
  }
}
</script>
