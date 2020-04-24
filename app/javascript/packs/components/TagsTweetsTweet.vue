<template>
  <v-card
    flat
    outlined
    max-width="500"
    class="mt-3"
    :href="tweetUrl"
  >
    <v-card-title>
      <v-list-item :href="userUrl">
        <v-list-item-avatar color="grey" size="40">
          <v-img
            src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
          />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>{{ user.name }}</v-list-item-title>
          <v-list-item-subtitle
            class="font-weight-light"
          >@{{ user.screen_name }}</v-list-item-subtitle>
        </v-list-item-content>
        <v-list-item-action>
          <v-icon color="blue">mdi-twitter</v-icon>
        </v-list-item-action>
      </v-list-item>
    </v-card-title>

    <v-card-text class="text--primary" v-html="tweet.oembed" />

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
      <span class="body-2 font-weight-light">{{ tweeted_at }}</span>
    </v-card-actions>
  </v-card>
</template>

<style scoped></style>

<style scoped>
.v-card {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
}
</style>
<script>
import moment from "moment"
import "moment/locale/ja"
moment.locale("ja")

export default {
  props: {
    tweet: {
      type: Object,
      default: () => {}
    },
    user: {
      type: Object,
      default: () => {}
    }
  },
  computed: {
    userUrl() {
      return `https://twitter.com/${this.user.screen_name}`
    },
    tweetUrl() {
      return `https://twitter.com/${this.user.screen_name}/status/${this.tweet.tweet_id}`
    },
    replyUrl() {
      return `https://twitter.com/intent/tweet?in_reply_to=${this.tweet.tweet_id}`
    },
    retweetUrl() {
      return `https://twitter.com/intent/retweet?tweet_id=${this.tweet.tweet_id}`
    },
    likeUrl() {
      return `https://twitter.com/intent/like?tweet_id=${this.tweet.tweet_id}`
    },
    buttons() {
      return [
        { url: this.replyUrl, color: "gray", icon: "mdi-chat-outline" },
        { url: this.retweetUrl, color: "green", icon: "mdi-twitter-retweet" },
        { url: this.likeUrl, color: "pink", icon: "mdi-heart-outline" }
      ]
    },
    tweeted_at() {
      return moment(this.tweet.tweeted_at).format("YYYY年M月D日(dd)H時m分")
    }
  }
}
</script>
