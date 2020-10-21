<template>
  <div>
    <h2 class="text-center my-7">継続率ランキング</h2>
    <!-- ランキング -->
    <v-card max-width="700" class="mx-auto mb-7">
      <v-list two-line subheader>
        <v-list-item
          v-for="(tag, index) in registeredTags"
          :key="tag.id"
          :to="{
            name: 'userTag',
            params: { tagId: tag.id, userUuid: tag.user.uuid }
          }"
          class="pl-0 px-sm-4"
        >
          <v-list-item-avatar size="40" class="mr-sm-7 mr-2">
            <v-icon>{{ rank(index) }}</v-icon>
          </v-list-item-avatar>

          <v-list-item-avatar color="grey" size="50" class="mr-sm-7 mr-2">
            <v-img :src="tag.user.avatarUrl" />
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title v-text="'#' + tag.tag.name" />
            <v-list-item-subtitle class="mt-1" v-text="'by ' + tag.user.name" />
          </v-list-item-content>

          <v-list-item-action
            class="ml-2"
          >{{ tag.tweetRate }}%</v-list-item-action>
          <v-list-item-action
            class="d-none d-sm-flex"
          >（{{ tag.tweetedDayCount }}日）</v-list-item-action>
        </v-list-item>
      </v-list>
    </v-card>
    <!-- ページネーション -->
    <div class="text-center">
      <v-pagination
        v-model="page.currentPage"
        :length="page.totalPages"
        :total-visible="7"
        @input="changePaginationPage"
      />
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      registeredTags: []
    }
  },
  mounted() {
    this.fetchRegisteredTagsData()
    document.title = "継続率ランキング - Hashlog"
  },
  methods: {
    rank(index) {
      const tagCountPerPage = 20
      const increase = (this.page.currentPage - 1) * tagCountPerPage
      const rank = increase + index + 1
      return rank
    },
    async fetchRegisteredTagsData() {
      const registeredTagsRes = await this.$axios.get(
        "/api/v1/registered_tags/persistences"
      )
      this.setPaginationData(registeredTagsRes)
      const { registeredTags } = registeredTagsRes.data
      this.registeredTags = registeredTags
    },
    // ページネーション
    setPaginationData(response) {
      this.page.totalPages = Number(response.headers["total-pages"])
      this.page.requestUrl = response.headers["request-url"]
    },
    async changePaginationPage(val) {
      this.$toTop()
      const res = await this.$axios.get(`${this.page.requestUrl}?page=${val}`)
      const { registeredTags } = res.data
      this.registeredTags = registeredTags
    }
  }
}
</script>

<style scoped>
h2 {
  color: #3b394d;
}
</style>
