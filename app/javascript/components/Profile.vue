<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container row>
        <v-col cols="12" lg="8">
          <!-- プロフィール -->
          <profile-view v-show="!isEditing" :user="user" />
          <!-- ユーザー編集 -->
          <profile-edit
            v-show="isEditing"
            @push-update="pushUpdate"
            @push-delete="pushDelete"
            @push-cencel="cancelEdit"
            :user="user"
          />
        </v-col>
        <v-col cols="9" lg="4">
          <!-- ステータス -->
          <profile-status :is-editing="isEditing" :user="user" />
        </v-col>
        <v-card-actions>
          <div v-show="!isEditing">
            <v-btn class="ma-2" outlined @click="pushEdit">
              <v-icon left>mdi-pencil</v-icon>編集
            </v-btn>
          </div>
        </v-card-actions>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import profileStatus from "./ProfileStatus"
import profileEdit from "./ProfileEdit"
import profileView from "./ProfileView"
export default {
  components: {
    profileView,
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
      isEditing: false,
      beforeUserData: {}
    }
  },
  computed: {
    twitterUrl() {
      return `https://twitter.com/${this.user.screen_name}`
    }
  },
  methods: {
    pushEdit() {
      this.isEditing = true
      this.beforeUserData = this.user
    },
    pushDelete() {
      this.$emit("push-delete")
    },
    pushUpdate() {
      this.$emit("push-update")
    },
    cancelEdit() {
      this.isEditing = false
      this.user = this.beforeUserData
    },
    finishEdit() {
      this.isEditing = false
    }
  }
}
</script>
