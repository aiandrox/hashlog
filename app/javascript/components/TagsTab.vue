<template>
  <v-container row>
    <div col="12" lg="10">
      <v-tabs>
        <v-tab :to="{ name: 'mypage' }">マイページ</v-tab>
        <v-tab
          v-for="registeredTag in registeredTags"
          :key="registeredTag.id"
          :to="{ name: 'mypageTag', params: { tag_id: registeredTag.id } }"
        >#{{ registeredTag.tag.name }}</v-tab>
      </v-tabs>
    </div>
    <v-spacer />
    <div col="2">
      <v-btn class="ma-2" color="primary" depressed @click="pushRegister">
        <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
      </v-btn>
      <!-- ダイアログ -->
      <register-tag-dialog ref="registerDialog" />
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
      default: () => []
    }
  },
  methods: {
    pushRegister() {
      this.$refs.registerDialog.open()
    }
  }
}
</script>
