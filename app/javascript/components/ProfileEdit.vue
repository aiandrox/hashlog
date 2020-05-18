<template>
  <ValidationObserver ref="observer" v-slot="{ invalid }">
    <v-list-item>
      <v-list-item-avatar color="grey" size="60">
        <v-img src />
      </v-list-item-avatar>
      <v-list-item-content>
        <v-list-item-title class="title">
          {{ user.name }}
          <v-btn icon color="blue" :href="twitterUrl">
            <v-icon>mdi-twitter</v-icon>
          </v-btn>
        </v-list-item-title>
        <v-list-item-subtitle>@{{ user.screenName }}</v-list-item-subtitle>
      </v-list-item-content>
    </v-list-item>
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
            :error-messages="errors"
            rows="3"
            label="プロフィール"
          />
        </ValidationProvider>
      </div>
    </v-card-text>
    <v-btn class="ma-2" outlined @click="pushCancel">キャンセル</v-btn>
    <v-btn class="ma-2" outlined @click="pushUpdate" :disabled="invalid">
      <v-icon left>mdi-content-save</v-icon>保存
    </v-btn>
    <v-spacer />
    <v-btn class="ma-2" color="error" outlined @click="pushDelete">
      <v-icon left>mdi-account-off</v-icon>ユーザー削除
    </v-btn>
  </ValidationObserver>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: () => {}
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
    pushDelete() {
      this.$emit("push-delete")
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
