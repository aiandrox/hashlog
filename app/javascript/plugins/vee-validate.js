import { ValidationProvider, ValidationObserver, extend } from "vee-validate"
import { required, max } from "vee-validate/dist/rules"

extend("required", {
  ...required,
  message: "{_field_}を入力してください"
})

extend("max", {
  ...max,
  message: "{_field_}は最大{length}文字です"
})

const filterTagName = value => value.replace(/^#+/, "")

extend("tagNameFormat", {
  validate(value) {
    return filterTagName(value).match(
      /^[Ａ-Ｚａ-ｚA-Za-z一-龠々0-9０-９ぁ-ヶｦ-ﾟー゛゜_]+$/
    )
  },
  message: "入力形式が不適です"
})

const filterRemindDay = value => {
  const stringRemindDay = String(value)
  if (stringRemindDay === null) {
    return null
  }
  const deleteDayResult = stringRemindDay.split("日").join("")
  const result = deleteDayResult.replace(/[０-９]/g, s =>
    String.fromCharCode(s.charCodeAt(0) - 65248)
  )
  // result => "-4", "20", "文字列"
  return Number(result)
}

extend("remindDayFormat", {
  validate(value) {
    return !isNaN(filterRemindDay(value))
  },
  message: "入力形式が不適です"
})

extend("maxRemindDay", {
  validate(value) {
    const maxDayCount = 30
    if (filterRemindDay(value) > maxDayCount) {
      return false
    }
    return true
  },
  message: "30日以下で設定してください"
})

extend("minRemindDay", {
  validate(value) {
    const minDayCount
    if (filterRemindDay(value) < minDayCount) {
      return false
    }
    return true
  },
  message: "1日以上で設定してください"
})

export default {
  components: {
    ValidationProvider,
    ValidationObserver
  }
}
