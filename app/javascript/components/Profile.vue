<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container row>
        <v-col cols="12" lg="8">
          <!-- プロフィール -->
          <profile-user :user="user" v-show="!isEditing" />
          <!-- ユーザー編集 -->
          <profile-edit :user="user" v-show="isEditing" />
          <v-card-actions>
            <div v-show="!isEditing">
              <v-btn class="ma-2" outlined @click="isEditing = true">
                <v-icon left>mdi-pencil</v-icon>編集
              </v-btn>
              <v-btn class="ma-2" outlined @click="showDialog">
                <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
              </v-btn>
            </div>
            <div v-show="isEditing">
              <v-btn class="ma-2" outlined @click="updateUserData">
                <v-icon left>mdi-pencil</v-icon>保存
              </v-btn>
              <v-btn class="ma-2" outlined @click="isEditing = false">キャンセル</v-btn>
              <!-- TODO: キャンセル時にデータを戻す -->
            </div>
          </v-card-actions>
          <!-- ダイアログ -->
          <register-tag-dialog ref="dialog" />
        </v-col>
        <v-col>
          <!-- ステータス -->
          <profile-status :role="user.role" :privacy="user.privacy" />
        </v-col>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import profileStatus from "./ProfileStatus"
import profileEdit from "./ProfileEdit"
import registerTagDialog from "./TheRegisterTagDialog"
import profileUser from "./ProfileUser"
export default {
  data() {
    return {
      loading: false,
      isEditing: false
    }
  },
  components: {
    profileUser,
    profileEdit,
    profileStatus,
    registerTagDialog
  },
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
    showDialog() {
      this.$refs.dialog.open()
    },
    updateUserData() {
      this.$emit("update-user-data")
    },
    finishEdit() {
      this.isEditing = false
    }
  }
}
</script>
