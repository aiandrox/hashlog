<template>
  <div style="max-width: 700px" class="mx-auto mt-3">
    <v-tabs background-color="#e9f1f5" grow>
      <v-tab
        v-for="rank in ranks"
        :key="rank.symbol"
        class="custom-transform-class text-none"
        :to="{ name: 'tagRanking', params: { type: rank.symbol } }"
        >{{ rank.name }}</v-tab
      >
    </v-tabs>
    <ranking
      :registered-tags="registeredTags"
      :current-page="page.currentPage"
    />
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
import ranking from "../components/Ranking"

export default {
  components: {
    ranking
  },
  data() {
    return {
      ranks: [
        { name: "継続率ランキング", symbol: "persistences" },
        { name: "日数ランキング", symbol: "day_counts" }
      ],
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      registeredTags: []
    }
  },
  watch: {
    $route() {
      this.fetchRegisteredTagsData()
    }
  },
  mounted() {
    this.fetchRegisteredTagsData()
    document.title = "ランキング - Hashlog"
  },
  methods: {
    async fetchRegisteredTagsData() {
      const { type } = this.$route.params
      const registeredTagUrl = `/api/v1/registered_tags/${type}`
      const registeredTagsRes = await this.$axios.get(registeredTagUrl)
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
