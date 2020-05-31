<template>
  <v-container row>
    <div col="12" lg="10">
      <v-tabs background-color="#e9f1f5" show-arrows>
        <v-tab :to="homePositionRoute">{{ homePositionName }}</v-tab>
        <v-tab
          class="custom-transform-class text-none"
          v-for="registeredTag in registeredTags"
          :key="registeredTag.id"
          :to="registeredTagRoute(registeredTag)"
          >#{{ registeredTag.tag.name }}</v-tab
        >
      </v-tabs>
    </div>
    <v-spacer />
    <div v-if="isMypage" col="2">
      <v-btn class="ma-2" color="primary" depressed @click="pushRegister">
        <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
      </v-btn>
      <!-- ダイアログ -->
      <register-tag-dialog ref="registerDialog" />
    </div>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex"
import registerTagDialog from "../components/TheRegisterTagDialog"

export default {
  components: {
    registerTagDialog
  },
  props: {
    registeredTags: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    ...mapGetters({ pageType: "page/type" }),
    isMypage() {
      return this.pageType === "mypage"
    },
    homePositionName() {
      if (this.pageType === "mypage") {
        return "マイページ"
      }
      return "ユーザーページ"
    },
    homePositionRoute() {
      if (this.pageType === "mypage") {
        return { name: "mypage" }
      }
      const { userUuid } = this.$route.params
      return { name: "user", params: { userUuid } }
    }
  },
  methods: {
    registeredTagRoute(registeredTag) {
      if (this.pageType === "mypage") {
        return { name: "myTag", params: { tagId: registeredTag.id } }
      }
      const { userUuid } = this.$route.params
      return { name: "userTag", params: { userUuid, tagId: registeredTag.id } }
    },
    pushRegister() {
      this.$refs.registerDialog.open()
    }
  }
}
</script>
