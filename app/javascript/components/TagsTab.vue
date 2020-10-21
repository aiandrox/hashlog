<template>
  <v-container row>
    <div col="12" lg="10">
      <v-tabs background-color="#e9f1f5" show-arrows>
        <v-tab :to="homePositionRoute">{{ homePositionName }}</v-tab>
        <v-tab
          v-for="registeredTag in registeredTags"
          :key="registeredTag.id"
          class="custom-transform-class text-none"
          :to="registeredTagRoute(registeredTag)"
        >#{{ registeredTag.tag.name }}</v-tab>
      </v-tabs>
    </div>
    <v-spacer />
    <div v-if="isMypage" col="2">
      <v-btn
        class="ma-2"
        color="primary"
        depressed
        @click="$refs.registerDialog.open()"
      >
        <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
      </v-btn>
      <!-- ダイアログ -->
      <register-tag-dialog
        ref="registerDialog"
      />
    </div>
  </v-container>
</template>

<script>
import registerTagDialog from "../components/TheRegisterTagDialog"

export default {
  components: {
    registerTagDialog
  },
  props: {
    registeredTags: {
      type: Array,
      default: () => [],
      required: true
    }
  },
  computed: {
    isMypage() {
      return this.$route.path.includes("/mypage/")
    },
    homePositionName() {
      if (this.isMypage) {
        return "マイページ"
      }
      return "ユーザーページ"
    },
    homePositionRoute() {
      if (this.isMypage) {
        return { name: "mypage" }
      }
      const { userUuid } = this.$route.params
      return { name: "user", params: { userUuid } }
    }
  },
  methods: {
    registeredTagRoute(registeredTag) {
      if (this.isMypage) {
        return { name: "myTag", params: { tagId: registeredTag.id } }
      }
      const { userUuid } = this.$route.params
      return { name: "userTag", params: { userUuid, tagId: registeredTag.id } }
    }
  }
}
</script>
