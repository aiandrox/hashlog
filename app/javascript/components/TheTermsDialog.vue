<template>
  <div>
    <v-row justify="center">
      <v-dialog v-model="isDialog" scrollable max-width="600px">
        <v-card>
          <v-card-text />
          <v-card-text style="height: 90%;"><the-terms /></v-card-text>

          <v-divider />
          <v-card-actions>
            <v-spacer />
            <ValidationObserver ref="observer" v-slot="{ invalid }">
              <ValidationProvider rules="required">
                <v-checkbox
                  v-model="checkbox"
                  value="1"
                  label="利用規約に同意する"
                  type="checkbox"
                  required
                />
              </ValidationProvider>
              <v-btn text @click="cancel">キャンセル</v-btn>
              <v-btn
                color="primary"
                text
                :disabled="invalid"
                href="/api/v1/oauth/twitter"
                @click="isDialog = false"
              >登録する</v-btn>
            </ValidationObserver>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
  </div>
</template>

<script>
import TheTerms from "./TheTerms"

export default {
  components: {
    TheTerms
  },
  data() {
    return {
      isDialog: false,
      isLoading: false,
      checkbox: null
    }
  },
  methods: {
    open() {
      this.isDialog = true
    },
    cancel() {
      this.checkbox = null
      this.isDialog = false
      this.$refs.observer.reset()
    }
  }
}
</script>

<style scoped>
.v-input--selection-controls {
  margin-top: 10px;
  margin-left: 5px;
}
.v-input__slot {
  margin-bottom: 0;
}
</style>
