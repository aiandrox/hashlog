<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container>
        <v-card-text>
          <div class="mb-3">
            <span class="title text--primary">
              {{ user.name }}
              <a target="blank" :href="twitter_url">
                <v-icon color="blue">mdi-twitter</v-icon>
              </a>
            </span>
            <span>@{{ user.screen_name }}</span>
          </div>
          <div class="body-1">
            {{ user.description }}
          </div>
        </v-card-text>
        <v-card-actions>
          <v-btn class="ma-2" outlined color="success">
            <v-icon left>mdi-pencil</v-icon> 編集
          </v-btn>
        </v-card-actions>
      </v-container>
    </v-card>
  </div>
</template>

<script>
export default {
  computed: {
    twitter_url: function() {
      return `https://twitter.com/${this.user.screen_name}`;
    },
  },
  props: {
    user: {
      type: Object,
      default: () => {},
    },
  },
};
</script>
