<template>
  <v-row justify-center>
    <v-dialog v-model="dialog" max-width="600px">
      <ValidationObserver ref="observer" v-slot="{ invalid }">
        <v-card>
          <v-system-bar
            class="pa-5 subtitle-1"
          >ツイートする</v-system-bar>
          <v-card-text class="mt-2">
            <v-container>
              <v-form @submit.prevent="onSubmit">
                <ValidationProvider
                  ref="provider"
                  v-slot="{ errors }"
                  name="本文"
                  :rules="`max:140|requiredTagName:${tagName}`"
                >
                  <v-textarea
                    v-model="tweetBody"
                    :counter="140"
                    :error-messages="errors"
                    rows="5"
                    label="本文"
                    persistent-hint
                    required
                  />
                </ValidationProvider>
              </v-form>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer />
            <v-btn text @click="resetForm">キャンセル</v-btn>
            <v-btn
              text
              color="primary"
              :disabled="invalid"
              @click="sendTweetBody"
            >ツイートする</v-btn>
          </v-card-actions>
        </v-card>
      </ValidationObserver>
      <!-- ローディング -->
      <loading-circle v-if="isLoading" />
    </v-dialog>
  </v-row>
</template>

<script>
import loadingCircle from "./shared/TheLoading"

export default {
  components: {
    loadingCircle
  },
  data() {
    return {
      dialog: false,
      isLoading: false,
      tweetBody: ""
    }
  },
  props: {
    tweetedDayCount: {
      type: Number,
      default: 0,
      required: true
    },
    lastTweetedAt: {
      type: String,
      default: "",
      required: true
    },
    tagName: {
      type: String,
      default: "",
      required: true
    }
  },
  computed: {
    todayCount() {
      const lastTweetedAt = Date.parse(this.lastTweetedAt)
      const today = new Date().setHours(0, 0, 0, 0)
      if (today <= lastTweetedAt) {
        return `${this.tweetedDayCount}日目`
      }
      return `${this.tweetedDayCount + 1}日目`
    },
  },
  methods: {
    open() {
      this.tweetBody = `#${this.tagName} #${this.todayCount}`
      this.dialog = true
    },
    resetForm() {
      this.dialog = false
      this.tweetBody = `#${this.tagName} #${this.todayCount}`
      this.$nextTick(() => {
        this.$refs.observer.reset()
      })
    },
    async sendTweetBody() {
      const isValid = await this.$refs.observer.validate()
      // disableにしているから大丈夫のはずだけど、一応バリデーションを通らないとリクエストを送れないようにしている
      if (isValid) {
        try {
          this.isLoading = true
          const { tagId } = this.$route.params
          const registeredTagRes = await this.$axios.post(
            `/api/v1/registered_tags/${tagId}/tweets`,
            {
              tweet: {
                body: this.tweetBody
              }
            }
          )
          this.$router.go({ path: this.$router.currentRoute.path, force: true })
          this.$store.dispatch("flash/setFlash", {
            type: "success",
            message: "ツイートしました"
          })
          this.resetForm()
        } catch (error) {
          const unprocessableEntityStatus = 422
          const tooManyRequestsStatus = 429
          switch (error.response.status) {
            case unprocessableEntityStatus: {
              const [errorMessage] = error.response.data.error.messages
              this.$refs.provider.errors.push(errorMessage)
              break
            }
            case tooManyRequestsStatus: {
              const [errorMessage] = error.response.data.error.messages
              this.$refs.provider.errors.push(errorMessage)
              break
            }
            default:
              throw error
          }
        } finally {
          this.isLoading = false
          this.$emit("finish-tweet")
        }
      }
    }
  }
}
</script>
