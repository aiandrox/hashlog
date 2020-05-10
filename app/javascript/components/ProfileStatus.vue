<template>
  <v-card flat>
    <v-list :class="{'v-list-item--disabled': !isEditing}">
      <v-subheader>STATUS</v-subheader>
      <v-list-item @click="togglePrivacy">
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
        :class="{'v-list-item--disabled': isEditing}"
      >
        <v-list-item-icon>
          <v-icon>{{ status.icon }}</v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>{{ status.text }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-card>
</template>

<script>
export default {
  props: {
    isEditing: {
      type: Boolean,
      default: false
    },
    user: {
      role: {
        type: String,
        default: ""
      },
      privacy: {
        type: String,
        default: ""
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
    }
  },
  methods: {
    togglePrivacy() {
      if (this.user.privacy === "公開") {
        this.user.privacy = "非公開"
      } else {
        this.user.privacy = "公開"
      }
    }
  }
}
</script>
