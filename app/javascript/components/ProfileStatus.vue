<template>
  <v-card flat>
    <v-list disabled>
      <v-subheader>STATUS</v-subheader>
      <v-list-item-group color="primary">
        <v-list-item v-for="status in statusArray" :key="status.name">
          <v-list-item-icon>
            <v-icon>{{ status.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ status.text }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
  </v-card>
</template>

<script>
export default {
  props: {
    role: {
      type: String,
      default: ""
    },
    privacy: {
      type: String,
      default: ""
    }
  },
  computed: {
    statusArray() {
      return [
        {
          name: "role",
          icon: "mdi-account",
          text: this.role
        },
        {
          name: "privacy",
          icon: "mdi-earth",
          text: this.privacy
        }
      ]
    }
  }
}
</script>
