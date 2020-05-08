<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container class="d-flex flex-row">
        <v-row>
          <v-col cols="12" lg="8">
            <profile-user :user="user"></profile-user>
            <v-card-actions>
              <v-btn class="ma-2" outlined>
                <v-icon left>mdi-pencil</v-icon>編集
              </v-btn>
              <v-btn class="ma-2" outlined @click="showDialog">
                <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
              </v-btn>
            </v-card-actions>
            <!-- ダイアログ -->
            <register-tag-dialog ref="dialog" />
          </v-col>
          <v-col>
            <!-- ステータス -->
            <profile-status :role="user.role" :privacy="user.privacy" />
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import ProfileStatus from "./ProfileStatus"
import RegisterTagDialog from "./TheRegisterTagDialog"
import ProfileUser from "./ProfileUser"
export default {
  data() {
    return { loading: false }
  },
  components: {
    ProfileUser,
    ProfileStatus,
    RegisterTagDialog
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
    }
  }
}
</script>
