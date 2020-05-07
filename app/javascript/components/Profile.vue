<template>
  <div class="my-5">
    <v-card class="mx-auto" outlined>
      <v-container class="d-flex flex-row">
        <div>
          <v-list-item>
            <v-list-item-avatar color="grey" size="60">
              <v-img
                src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
              />
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
          <v-card-actions>
            <v-btn class="ma-2" outlined color="success">
              <v-icon left>mdi-pencil</v-icon>編集
            </v-btn>
            <v-btn class="ma-2" outlined color="success" @click="showDialog">
              <v-icon left>mdi-pound</v-icon>ハッシュタグを登録する
            </v-btn>
          </v-card-actions>
          <!-- ダイアログ -->
          <register-tag-dialog ref="dialog" />
        </div>
        <v-spacer />
        <!-- ステータス -->
        <profile-status :role="user.role" :privacy="user.privacy" />
      </v-container>
    </v-card>
  </div>
</template>

<script>
import ProfileStatus from "./ProfileStatus"
import RegisterTagDialog from "./TheRegisterTagDialog"
export default {
  data() {
    return { loading: false }
  },
  components: {
    ProfileStatus,
    RegisterTagDialog
  },
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
  },
  methods: {
    showDialog() {
      this.$refs.dialog.open()
    }
  }
}
</script>
