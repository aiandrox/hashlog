<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      max-width="600px"
    >
      <v-card>
        <v-card-title class="pt-5">
          新規ハッシュタグ登録
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-text-field
              v-model="tagName"
              label="ハッシュタグ"
              hint="#を含めず入力してください"
              persistent-hint
              required
            >
              <v-icon slot="prepend">
                mdi-pound
              </v-icon>
            </v-text-field>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn
            color="blue darken-1"
            text
            @click="close()"
          >
            キャンセル
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="pushRegister(), close()"
          >
            登録する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      tagName: ''
    }
  },
  methods: {
    open() {
      this.dialog = true
    },
    close() {
      this.dialog = false
    },
    pushRegister() {
      this.$emit('push-register', this.tagName)
    }
  }
}
</script>
