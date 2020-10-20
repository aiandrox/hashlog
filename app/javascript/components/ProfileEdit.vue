<template>
  <ValidationObserver ref="observer" v-slot="{ invalid }">
    <v-card-text class="my-0">
      <div class="body-1">
        <ValidationProvider
          v-slot="{ errors }"
          name="プロフィール"
          rules="max:300"
        >
          <v-textarea
            v-model="user.description"
            outlined
            :counter="300"
            messages="この変更はTwitterには反映されません"
            :error-messages="errors"
            rows="5"
            label="プロフィール"
          />
        </ValidationProvider>
      </div>
    </v-card-text>
    <v-btn
      class="ma-2"
      outlined
      color="primary"
      @click="pushCancel"
    >キャンセル</v-btn>
    <v-btn
      class="ma-2"
      depressed
      dark
      color="depressedButton"
      :disabled="invalid"
      @click="pushUpdate"
    >保存する</v-btn>
    <v-spacer />
    <v-btn class="ma-2" color="error" outlined @click="$emit('push-delete')">
      <v-icon left>mdi-account-off</v-icon>ユーザー削除
    </v-btn>
  </ValidationObserver>
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
      return `https://twitter.com/${this.user.screen_name}`
    }
  },
  methods: {
    async pushUpdate() {
      const isValid = await this.$refs.observer.validate()
      // disableにしているから大丈夫のはずだけど、一応バリデーションを通らないとリクエストを送れないようにしている
      if (isValid) {
        this.$emit("push-update")
      }
    },
    pushCancel() {
      this.$nextTick(() => {
        this.$refs.observer.reset()
      })
      this.$emit("push-cencel")
    }
  }
}
</script>

<style scoped>
.theme--dark.v-btn.v-btn--disabled:not(.v-btn--flat):not(.v-btn--text):not(.v-btn--outlined) {
  color: #000;
}
</style>
