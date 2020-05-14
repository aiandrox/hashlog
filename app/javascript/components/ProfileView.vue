<template>
  <div>
    <v-list-item>
      <v-list-item-avatar color="grey" size="60">
        <v-img src="" />
      </v-list-item-avatar>
      <v-list-item-content>
        <v-list-item-title class="title">
          {{ user.name }}
          <v-btn icon color="blue" :href="twitterUrl">
            <v-icon>mdi-twitter</v-icon>
          </v-btn>
        </v-list-item-title>
        <v-list-item-subtitle>@{{ user.screenName }}</v-list-item-subtitle>
      </v-list-item-content>
    </v-list-item>
    <v-card-text>
      <div class="body-1">{{ user.description }}</div>
    </v-card-text>
  </div>
</template>

<script>
export default {
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
  }
}
</script>
