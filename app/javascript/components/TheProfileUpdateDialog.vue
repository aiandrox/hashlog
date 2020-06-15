<template>
  <v-layout justify-center>
    <v-dialog v-model="dialog" max-width="480px">
      <v-card>
        <v-system-bar class="pa-5 subtitle-1"
          >ユーザー情報を更新しますか？</v-system-bar
        >
        <v-card-text class="mt-8">
          <p>
            以下の情報をTwitterから取得し、ユーザー情報の更新を行います。
          </p>
          <ul>
            <li>
              ユーザー名
            </li>
            <li>@から始まるアカウント名</li>
            <li>プロフィール画像</li>
          </ul>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn text @click="dialog = false">キャンセル</v-btn>
          <v-btn text color="primary" @click="pushUpdate">更新する</v-btn>
        </v-card-actions>
      </v-card>
      <!-- ローディング -->
      <loading v-if="loading" />
    </v-dialog>
  </v-layout>
</template>

<script>
import loading from "./shared/TheLoading"

export default {
  components: {
    loading
  },
  data() {
    return {
      dialog: false,
      loading: false
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    close() {
      this.dialog = false
      this.loading = false
    },
    pushUpdate() {
      this.$emit("push-update")
      this.loading = true
    }
  }
}
</script>
