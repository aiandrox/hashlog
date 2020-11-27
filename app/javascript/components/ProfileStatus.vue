<template>
  <v-card flat>
    <v-list :class="{ 'v-list-item--disabled': !isEditing }">
      <v-subheader>STATUS</v-subheader>
      <v-list-item @click="$emit('click-privacy')">
        <v-list-item-icon>
          <v-icon>mdi-earth</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>{{ user.privacy }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list-item
        v-for="status in statusArray"
        :key="status.name"
        :class="{ 'v-list-item--disabled': isEditing }"
      >
        <v-list-item-icon>
          <v-icon>{{ status.icon }}</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>{{ status.text }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
    <v-btn
      v-if="isMypage"
      class="ma-2"
      color="primary"
      outlined
      @click="$emit('push-twitter-update')"
    >
      <v-icon left>mdi-twitter</v-icon>ユーザーを更新
    </v-btn>
  </v-card>
</template>

<script>
export default {
  props: {
    isEditing: {
      type: Boolean,
      default: false,
      required: true
    },
    user: {
      type: Object,
      default: () => {},
      required: true,
      role: {
        type: String,
        default: "",
        required: true
      },
      privacy: {
        type: String,
        default: "",
        required: true
      }
    }
  },
  computed: {
    statusArray() {
      return [
        {
          name: "role",
          icon: "mdi-account",
          text: this.user.role
        }
      ]
    },
    isMypage() {
      return this.$route.path.includes("/mypage/")
    }
  }
}
</script>
