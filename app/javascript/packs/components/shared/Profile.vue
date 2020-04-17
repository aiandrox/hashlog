<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container class="d-flex flex-row">
        <div>
          <v-list-item>
            <v-list-item-avatar color="grey" size="60">
              <v-img
                src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
              ></v-img>
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title class="title">
                {{ user.name }}
                <v-btn icon color="blue" :href="twitter_url">
                  <v-icon>mdi-twitter</v-icon>
                </v-btn>
              </v-list-item-title>
              <v-list-item-subtitle>@{{ user.screen_name }}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <v-card-text>
            <div class="body-1">{{ user.description }}</div>
          </v-card-text>
          <v-card-actions>
            <v-btn class="ma-2" outlined color="success">
              <v-icon left>mdi-pencil</v-icon>編集
            </v-btn>
            <v-btn class="ma-2" outlined color="success">
              <v-icon left>mdi-pencil</v-icon>タグの作成
            </v-btn>
          </v-card-actions>
        </div>
        <status :role="user.role" :privacy="user.privacy"></status>
      </v-container>
    </v-card>
  </div>
</template>

<script>
import Status from "./ProfileStatus";
export default {
  components: {
    Status
  },
  computed: {
    twitter_url() {
      return `https://twitter.com/${this.user.screen_name}`;
    }
  },
  props: {
    user: {
      type: Object,
      default: () => {}
    }
  }
};
</script>
