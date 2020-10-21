<template>
  <!-- 編集部分 -->
  <v-list>
    <status-edit
      v-if="isEditing"
      ref="editArea"
      :registered-tag="registeredTag"
      @input-privacy="inputPrivacy"
      @input-remind-day="inputRemindDay"
      @push-update="$emit('push-update')"
      @push-cancel="pushCancel"
      @push-delete="$emit('push-delete')"
    />
    <!-- ビュー部分 -->
    <status-view v-if="!isEditing" :registered-tag="registeredTag" />
    <v-list-item v-if="isMypage && !isEditing">
      <v-btn class="ml-2 mb-2" outlined color="primary" @click="pushEdit">
        <v-icon left>mdi-cog</v-icon>設定
      </v-btn>
    </v-list-item>
  </v-list>
</template>

<script>
import statusView from "./TagStatusView"
import statusEdit from "./TagStatusEdit"
export default {
  components: {
    statusView,
    statusEdit
  },
  props: {
    registeredTag: {
      type: Object,
      default: () => {},
      required: true
    }
  },
  data() {
    return {
      isEditing: false
    }
  },
  computed: {
    isMypage() {
      return this.$route.path.includes("/mypage/")
    }
  },
  watch: {
    $route() {
      this.isEditing = false
    }
  },
  methods: {
    date(date) {
      if (date === null) {
        return "まだツイートはありません"
      }
      return this.$fullDateFormat(date)
    },
    async pushEdit() {
      await (this.isEditing = true)
      this.$refs.editArea.fetchSelectFromRemindDay()
    },
    pushCancel() {
      this.isEditing = false
      this.$emit("push-cancel")
    },
    finishEdit() {
      this.isEditing = false
    },
    // regsiteredTagの設定変更を反映
    inputPrivacy(v) {
      this.$emit("input-privacy", v)
    },
    inputRemindDay(v) {
      this.$emit("input-remind-day", v)
    }
  }
}
</script>
