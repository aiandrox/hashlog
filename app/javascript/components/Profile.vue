<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container row>
        <v-col cols="12" lg="8">
          <!-- プロフィール -->
          <profile-user v-show="!isEditing" :user="user" />
          <!-- ユーザー編集 -->
          <profile-edit v-show="isEditing" :user="user" />
        </v-col>
        <v-col cols="9" lg="4">
          <!-- ステータス -->
          <profile-status :is-editing="isEditing" :user="user" />
        </v-col>
        <v-card-actions>
          <div v-show="!isEditing">
            <v-btn class="ma-2" outlined @click="isEditing = true">
              <v-icon left>mdi-pencil</v-icon>編集
            </v-btn>
          </div>
          <div v-show="isEditing">
            <v-btn
              class="ma-2"
              outlined
              @click="isEditing = false"
            >キャンセル</v-btn>
            <v-btn class="ma-2" outlined @click="updateUserData">
              <v-icon left>mdi-content-save</v-icon>保存
            </v-btn>
            <v-spacer />
            <v-btn class="ma-2" color="error" outlined @click="pushDelete">
              <v-icon left>mdi-account-off</v-icon>ユーザー削除
            </v-btn>
            <!-- TODO: キャンセル時にデータを戻す -->
          </div>
        </v-card-actions>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import profileStatus from "./ProfileStatus"
import profileEdit from "./ProfileEdit"
import profileUser from "./ProfileUser"
export default {
  components: {
    profileUser,
    profileEdit,
    profileStatus
  },
  props: {
    user: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      isEditing: false
    }
  },
  computed: {
    twitterUrl() {
      return `https://twitter.com/${this.user.screen_name}`
    }
  },
  methods: {
    pushDelete() {
      this.$emit("push-delete")
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
