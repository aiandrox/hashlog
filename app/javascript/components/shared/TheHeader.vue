<template>
  <v-app-bar app flat dark color="#006596">
    <v-toolbar-title v-if="!isTopPage" color="#f0faff">Hashlog</v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <v-btn v-if="!currentUser" text @click="pushLogin">ログイン</v-btn>
      <v-btn v-if="currentUser" text :to="{ name: 'mypage' }">マイページ</v-btn>
      <v-btn v-if="currentUser" text @click="logout">ログアウト</v-btn>
    </v-toolbar-items>
    <!-- 利用規約ダイアログ -->
    <the-terms-dialog ref="termsDialog" />
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex"
import theTermsDialog from "../TheTermsDialog"

export default {
  components: {
    theTermsDialog
  },
  computed: {
    ...mapGetters({ currentUser: "user/currentUser" }),
    isTopPage() {
      return this.$route.path === "/"
    }
  },
  methods: {
    async logout() {
      await this.$store.dispatch("user/logout")
      this.$router.push({ name: "top" })
      this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ログアウトしました"
      })
    },
    pushLogin() {
      this.$refs.termsDialog.open()
    }
  }
}
</script>
