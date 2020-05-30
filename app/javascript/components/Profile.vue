<template>
  <div class="my-5 main-content">
    <v-card class="mx-auto" outlined>
      <v-container row>
        <v-col cols="12" lg="8">
          <!-- プロフィール -->
          <profile-view v-if="!isEditing" :user="user" @push-edit="isEditing = true" />
          <!-- ユーザー編集 -->
          <profile-edit
            v-if="isEditing"
            :user="user"
            @push-update="pushUpdate"
            @push-delete="pushDelete"
            @push-cencel="pushCancel"
          />
        </v-col>
        <v-col cols="9" lg="4">
          <!-- ステータス -->
          <profile-status :is-editing="isEditing" :user="user" />
        </v-col>
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
    pushCancel() {
      this.isEditing = false
      this.$emit("push-cancel")
    },
    finishEdit() {
      this.isEditing = false
    }
  }
}
</script>
