<template>
  <div>
    <h2 class="text-center my-7">継続率ランキング</h2>
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
      page: {
        currentPage: 1,
        totalPages: 1,
        requestUrl: ""
      },
      registeredTags: []
    }
  },
  computed: {
    registeredTagUrl() {
      const { type } = this.$route.params
      return `/api/v1/registered_tags/${type}`
    }
  },
  watch: {
    $route() {
      this.firstRead()
    }
  },
  mounted() {
    this.fetchRegisteredTagsData()
    document.title = "継続率ランキング - Hashlog"
  },
  methods: {
    async fetchRegisteredTagsData() {
      const registeredTagsRes = await this.$axios.get(this.registeredTagUrl)
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
