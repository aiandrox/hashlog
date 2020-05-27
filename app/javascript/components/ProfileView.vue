<template>
  <div>
    <v-list-item>
      <v-list-item-avatar color="grey" size="60">
        <v-img :src="user.avatarUrl" />
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
      <div
        class="body-1"
        style="white-space: pre-line;word-wrap: break-word"
        v-html="$sanitize(replacedDescription)"
      />
    </v-card-text>
    <div>
      <v-btn class="ma-2" outlined @click="pushEdit">
        <v-icon left>mdi-pencil</v-icon>編集
      </v-btn>
    </div>
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
    },
    replacedDescription() {
      const replaced = this.user.description.replace(
        /(https?:\/\/[\w!-/:-@¥[-`{-~]*)/g,
        "<a href='$1' target='_blank'>$1</a>"
      )
      return replaced
    }
  },
  methods: {
    pushEdit() {
      this.$emit("push-edit")
    }
  }
}
</script>
