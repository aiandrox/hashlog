<template>
  <v-row justify="center">
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-card-title class="pt-5">新規ハッシュタグ登録</v-card-title>
        <v-card-text>
          <v-container>
            <v-text-field
              v-model="tagName"
              label="ハッシュタグ"
              hint="#を含めず入力してください"
              persistent-hint
              required
            >
              <v-icon slot="prepend">mdi-pound</v-icon>
            </v-text-field>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="blue darken-1" text @click="dialog = false">キャンセル</v-btn>
          <v-btn color="blue darken-1" text @click="sendTagName">登録する</v-btn>
        </v-card-actions>
      </v-card>
      <!-- ローディング -->
      <loading v-show="loading" />
    </v-dialog>
  </v-row>
</template>

<script>
import Axios from "axios"
import Loading from "./shared/TheLoading"
export default {
  data() {
    return {
      dialog: false,
      tagName: "",
      loading: false
    }
  },
  components: {
    Loading
  },
  methods: {
    open() {
      this.dialog = true
    },
    sendTagName() {
      this.loading = true
      Axios.post("/api/v1/registered_tags", {
        tag: {
          name: this.tagName
        }
      })
        .then(response => {
          const tagId = response.data.tag_id
          const successOrFailure = response.data.flash.type
          if (successOrFailure === "success") {
            this.dialog = false
            this.$router.push({ path: `/mypage/tags/${tagId}` })
          }
        })
        .catch(response => {
          console.log(response)
        })
        .finally(() => {
          this.loading = false
        })
    }
  }
}
</script>
