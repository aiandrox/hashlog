<template>
  <div class="my-5 main-content">
    <v-card class="mx-auto" outlined>
      <v-container row>
        <v-col cols="12" md="9">
          <!-- Twitter情報 -->
          <v-list-item>
            <v-list-item-avatar color="grey" size="60">
              <v-img :src="user.avatarUrl" />
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title class="title">{{ user.name }}</v-list-item-title>
              <v-list-item-subtitle>
                @{{ user.screenName }}
                <v-btn icon color="blue" :href="twitterUrl">
                  <v-icon>mdi-twitter</v-icon>
                </v-btn>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <!-- プロフィール詳細部分 -->
          <profile-view v-if="!isEditing" :user="user" @push-edit="isEditing = true" />
          <!-- ユーザー編集部分 -->
          <profile-edit
            v-if="isEditing"
            :user="user"
            @push-update="$emit('push-update')"
            @push-delete="$emit('push-delete')"
            @push-cencel="pushCancel"
          />
        </v-col>
        <v-col cols="9" md="3">
          <!-- ステータス -->
          <profile-status
            :is-editing="isEditing"
            :user="user"
            @push-twitter-update="$emit('push-twitter-update')"
          />
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
      default: () => {},
      required: true
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
      return `https://twitter.com/${this.user.screenName}`
    }
  },
  methods: {
    pushEdit() {
      this.isEditing = true
      this.beforeUserData = this.user
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
