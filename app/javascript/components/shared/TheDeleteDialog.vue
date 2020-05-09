<template>
  <v-layout justify-center>
    <v-dialog v-model="dialog" max-width="380px">
      <v-card>
        <v-system-bar class="pa-5 subtitle-1"
          >本当に削除しますか？</v-system-bar
        >
        <v-card-text class="mt-8">
          <slot />
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn text color="error" @click="pushDelete">削除する</v-btn>
          <v-btn text @click="dialog = false">キャンセル</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <!-- ローディング -->
    <loading v-show="loading" />
  </v-layout>
</template>

<script>
import loading from "./TheLoading"
export default {
  data() {
    return {
      dialog: false,
      loading: false
    }
  },
  components: {
    loading
  },
  methods: {
    open() {
      this.dialog = true
    },
    pushDelete() {
      this.$emit("push-delete")
    }
  }
}
</script>
