<template>
  <div>
    <v-card
      flat
      outlined
      :ripple="false"
      max-width="500"
      class="mt-3"
      :href="tweetUrl"
    >
      <v-card-title>
        <v-list-item class="pl-0">
          <v-list-item :ripple="false" :href="userUrl">
            <v-list-item-avatar color="grey" size="40">
              <v-img :src="user.avatarUrl" />
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title>{{ user.name }}</v-list-item-title>
              <v-list-item-subtitle class="font-weight-light"
                >@{{ user.screenName }}</v-list-item-subtitle
              >
            </v-list-item-content>
          </v-list-item>
          <v-spacer />
          <v-list-item-action>
            <v-icon color="blue">mdi-twitter</v-icon>
          </v-list-item-action>
        </v-list-item>
      </v-card-title>

      <v-card-text class="text--primary" v-html="$sanitize(tweet.oembed)" />
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
        <span class="body-2 font-weight-light">
          {{ $fullDateFormat(tweet.tweetedAt) }}
        </span>
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
