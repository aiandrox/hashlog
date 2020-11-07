<template>
  <v-app-bar app flat dark color="#006596">
    <v-toolbar-title v-if="!isTopPage">
      <div class="logo mt-2" @click="toTopPage" />
    </v-toolbar-title>
    <v-spacer />
    <v-toolbar-items>
      <v-btn
        v-if="isTopPage"
        class="px-3 px-sm-4"
        text
        color="#ffffb5"
        :to="{ name: 'tagRanking' }"
        ><v-icon left class="d-none d-sm-flex">mdi-crown</v-icon
        >継続率ランキング</v-btn
      >
      <v-btn v-if="!currentUser" text @click="pushLogin">ログイン</v-btn>
      <v-btn
        v-if="currentUser"
        class="px-3 px-sm-4"
        text
        :to="{ name: 'mypage' }"
        >マイページ</v-btn
      >
      <v-btn v-if="currentUser" class="px-3 px-sm-4" text @click="logout"
        >ログアウト</v-btn
      >
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
      await this.$store.dispatch("flash/setFlash", {
        type: "success",
        message: "ログアウトしました"
      })
      location.reload()
    },
    pushLogin() {
      this.$refs.termsDialog.open()
    },
    toTopPage() {
      this.$router.push({ name: "top" })
      this.$toTop()
    }
  }
}
</script>

<style scoped>
.logo {
  height: 52px;
  width: 170px;
  background-size: contain;
  background-image: url("/img/logo-w.png");
  cursor: pointer;
}
</style>
