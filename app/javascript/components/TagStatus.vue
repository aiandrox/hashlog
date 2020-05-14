<template>
  <v-card flat>
    <!-- 編集部分 -->
    <status-edit
      v-if="isEditing"
      ref="editArea"
      :registered-tag="registeredTag"
      @push-update="pushUpdate"
      @push-cancel="pushCancel"
      @push-delete="pushDelete"
    />
    <!-- ビュー部分 -->
    <status-view v-if="!isEditing" :registered-tag="registeredTag" />
    <v-btn v-if="!isEditing" class="ma-2" outlined @click="pushEdit">
      <v-icon left>mdi-cog</v-icon>設定
    </v-btn>
  </v-card>
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
      default: () => {}
    }
  },
  data() {
    return {
      isEditing: false
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
      return this.dayjs(date)
    },
    pushEdit() {
      this.isEditing = true
      this.$refs.editArea.fetchSelectFromRemindDay()
    },
    pushDelete() {
      this.$emit("push-delete")
    },
    pushUpdate() {
      this.$refs.editArea.fetchRemindDayFromForm()
      this.$emit("push-update")
    },
    pushCancel() {
      this.isEditing = false
    },
    finishEdit() {
      this.isEditing = false
    }
  }
}
</script>
