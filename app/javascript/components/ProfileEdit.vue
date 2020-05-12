<template>
  <!-- <v-form v-model="valid"> -->
  <v-form>
    <v-list-item>
      <v-list-item-avatar color="grey" size="60">
        <v-img
          src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
        />
      </v-list-item-avatar>
      <v-list-item-content row>
        <v-col cols="12" md="5">
          <v-text-field
            v-model="user.name"
            :counter="30"
            label="ユーザーネーム"
            required
          />
        </v-col>
        <v-col cols="12" md="4" />
      </v-list-item-content>
    </v-list-item>
    <v-card-text class="my-0">
      <div class="body-1">
        <v-textarea
          v-model="user.description"
          outlined
          :counter="300"
          rows="3"
          label="プロフィール"
        />
      </div>
    </v-card-text>
  </v-form>
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
