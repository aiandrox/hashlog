<template>
  <v-card flat outlined max-width="500" class="mt-3">
    <!-- <v-card flat outlined max-width="500" class="mt-3" :href="this.tweetUrl"> -->
    <v-card-title>
      <v-list-item :href="this.userUrl">
        <v-list-item-avatar color="grey" size="40">
          <v-img
            src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
          ></v-img>
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>{{ user.name }}</v-list-item-title>
          <v-list-item-subtitle>@{{ user.screen_name }}</v-list-item-subtitle>
        </v-list-item-content>
        <v-list-item-action>
          <v-icon color="blue">mdi-twitter</v-icon>
        </v-list-item-action>
      </v-list-item>
    </v-card-title>

    <v-card-text class="text--primary" v-html="tweet.oembed"></v-card-text>

    <v-card-actions>
      <v-btn icon :href="this.replyUrl">
        <v-icon>mdi-chat-outline</v-icon>
      </v-btn>
      <v-btn icon :href="this.retweetUrl">
        <v-icon>mdi-twitter-retweet</v-icon>
      </v-btn>
      <v-btn icon :href="this.likeUrl">
        <v-icon>mdi-heart-outline</v-icon>
      </v-btn>
      <v-spacer></v-spacer>
      <span class="body-2">{{ tweet.tweeted_at }}</span>
    </v-card-actions>
  </v-card>
</template>

<style scoped>
.v-card {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
}
</style>
<script>
export default {
  computed: {
    userUrl() {
      return `https://twitter.com/${this.user.screen_name}`;
    },
    tweetUrl() {
      return `https://twitter.com/${this.user.screen_name}/status/${this.tweet.tweet_id}`;
    },
    replyUrl() {
      return `https://twitter.com/intent/tweet?in_reply_to=${this.tweet.tweet_id}`;
    },
    retweetUrl() {
      return `https://twitter.com/intent/retweet?tweet_id=${this.tweet.tweet_id}`;
    },
    likeUrl() {
      return `https://twitter.com/intent/like?tweet_id=${this.tweet.tweet_id}`;
    }
  },
  props: {
    tweet: {
      type: Object,
      default: () => {}
    },
    user: {
      type: Object,
      default: () => {}
    }
  }
};
</script>
