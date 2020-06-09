import dayjs from "dayjs"
import "dayjs/locale/ja"
dayjs.locale("ja")

export default {
  methods: {
    $fullDateFormat(date) {
      return dayjs(date).format("YYYY年M月D日(dd)H時m分")
    }
  }
}
