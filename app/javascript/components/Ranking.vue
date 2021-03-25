<template>
  <v-card class="mb-7">
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
          :class="isPersistence ? 'sm-1' : 'd-none d-sm-flex'"
        >{{ tag.tweetRate }}%</v-list-item-action>
        <v-list-item-action-text
          :class="isPersistence ? 'd-none d-sm-flex' : 'sm-1'"
        >（{{ tag.tweetedDayCount }}日）</v-list-item-action-text>
      </v-list-item>
    </v-list>
  </v-card>
</template>

<script>
export default {
  props: {
    registeredTags: {
      type: Array,
      default: () => [],
      required: true
    },
    currentPage: {
      type: Number,
      default: 1,
      required: true
    }
  },
  computed: {
    isPersistence() {
      const { type } = this.$route.params
      if (type === "persistences") {
        return true
      }
      return false
    }
  },
  methods: {
    rank(index) {
      const tagCountPerPage = 20
      const increase = (this.currentPage - 1) * tagCountPerPage
      const rank = increase + index + 1
      return rank
    }
  }
}
</script>
