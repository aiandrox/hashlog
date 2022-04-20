<template>
  <div>
    <v-card
      flat
      outlined
      :ripple="false"
      max-width="550"
      class="mt-3"
      :href="tweetUrl"
    >
      <v-card-title class="py-1">
        <v-list two-line max-width="530" width="100%">
          <v-list-item :ripple="false" :href="userUrl">
            <v-list-item-avatar color="grey" size="45">
              <v-img :src="user.avatarUrl" />
            </v-list-item-avatar>

            <v-list-item-content>
              <v-list-item-title v-text="user.name" />
              <v-list-item-subtitle
                class="font-weight-light"
              >@{{ user.screenName }}</v-list-item-subtitle>
            </v-list-item-content>
            <v-list-item-icon>
              <v-icon color="blue">mdi-twitter</v-icon>
            </v-list-item-icon>
          </v-list-item>
        </v-list>
      </v-card-title>

      <!-- eslint-disable -->
      <v-card-text class="text--primary" v-html="$sanitize(tweet.oembed)" />
      <!-- eslint-enable -->
      <v-container fluid>
        <v-row dense>
          <v-col v-for="image in tweet.images" :key="image.id">
            <v-img :src="image.src" />
          </v-col>
        </v-row>
      </v-container>
      <v-card-actions>
        <v-btn
          v-for="button in buttons"
          :key="button.icon"
          :href="button.url"
          :color="button.color"
          icon
        >
          <v-icon>{{ button.icon }}</v-icon>
        </v-btn>
        <v-spacer />
        <span class="body-2 font-weight-light">{{
          $fullDateFormat(tweet.tweetedAt)
        }}</span>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  props: {
    tweet: {
      type: Object,
      default: () => {},
      required: true
    },
    user: {
      type: Object,
      default: () => {},
      required: true
    }
  },
  computed: {
    userUrl() {
      return `https://twitter.com/${this.user.screenName}`
    },
    tweetUrl() {
      return `https://twitter.com/${this.user.screenName}/status/${this.tweet.tweetId}`
    },
    replyUrl() {
      return `https://twitter.com/intent/tweet?in_reply_to=${this.tweet.tweetId}`
    },
    retweetUrl() {
      return `https://twitter.com/intent/retweet?tweet_id=${this.tweet.tweetId}`
    },
    likeUrl() {
      return `https://twitter.com/intent/like?tweet_id=${this.tweet.tweetId}`
    },
    buttons() {
      return [
        { url: this.replyUrl, color: "gray", icon: "mdi-chat-outline" },
        { url: this.retweetUrl, color: "green", icon: "mdi-twitter-retweet" },
        { url: this.likeUrl, color: "pink", icon: "mdi-heart-outline" }
      ]
    },
    deleteUrl() {
      const { id } = this.tweet
      return `/api/v1/tweets/${id}`
    }
  }
}
</script>

<style scoped>
.v-list-item__subtitle {
  max-width: 100px;
}
</style>
