<template>
  <v-row justify-center>
    <v-dialog v-model="dialog" max-width="600px">
      <v-card>
        <v-system-bar class="pa-5 subtitle-1"
          >ハッシュタグを登録する</v-system-bar
        >
        <v-card-text class="mt-5">
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
          <v-btn text @click="dialog = false">キャンセル</v-btn>
          <v-btn text color="primary" @click="sendTagName">登録する</v-btn>
        </v-card-actions>
      </v-card>
      <!-- ローディング -->
      <loading v-show="loading" />
    </v-dialog>
  </v-row>
</template>

<script>
import axios from "axios"
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
      axios
        .post("/api/v1/registered_tags", {
          tag: {
            name: this.tagName
          }
        })
        .then(response => {
          const tagId = response.data.registeredTag.id
          this.dialog = false
          this.$router.push({ name: "mypageTag", params: { id: tagId } })
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
