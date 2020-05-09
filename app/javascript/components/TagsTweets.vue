<template>
  <div>
    <tweet
      v-for="tweet in tweets"
      :key="tweet.tweetId"
      :tweet="tweet"
      :user="user"
    />
  </div>
</template>
<script>
import tweet from "./TagsTweetsTweet"
export default {
  components: {
    tweet
  },
  props: {
    user: {
      type: Object,
      default: () => {}
    },
    tweets: {
      type: Array,
      default: () => []
    }
  }
}
</script>
