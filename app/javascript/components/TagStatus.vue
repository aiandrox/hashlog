<template>
  <v-card flat>
    <!-- ビュー部分 -->
    <status-view v-show="!isEditing" :registered-tag="registeredTag" />
    <!-- 編集部分 -->
    <status-edit v-show="isEditing" ref="editArea" :registered-tag="registeredTag" />
    <v-btn v-show="!isEditing" class="ma-2" outlined @click="pushEdit">
      <v-icon left>mdi-cog</v-icon>設定
    </v-btn>
    <div v-show="isEditing">
      <v-btn class="ma-2" outlined @click="isEditing = false">キャンセル</v-btn>
      <v-btn class="ma-2" outlined @click="pushSave">
        <v-icon left>mdi-content-save</v-icon>保存
      </v-btn>
      <v-btn class="ma-2" outlined color="error" @click="pushDelete">
        <v-icon left>mdi-delete</v-icon>ハッシュタグを削除
      </v-btn>
    </div>
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
    $route: "resetEditing"
  },
  methods: {
    pushDelete() {
      this.$emit("push-delete")
    },
    date(date) {
      if (date === null) {
        return "まだツイートはありません"
      }
      return this.dayjs(date)
    },
    pushEdit() {
      this.isEditing = true
      this.$refs.editArea.checkReminder()
    },
    pushSave() {
      this.$emit("push-update")
      this.isEditing = false
      // 再描画
    },
    resetEditing() {
      this.isEditing = false
    }
  }
}
</script>
