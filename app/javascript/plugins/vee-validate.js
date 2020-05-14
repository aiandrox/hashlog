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

const filter = remindDay => {
  const stringRemindDay = String(remindDay)
  if (stringRemindDay === null) {
    return 0
  }
  const deleteDayResult = stringRemindDay.split("日").join("")
  const result = deleteDayResult.replace(/[０-９]/g, s =>
    String.fromCharCode(s.charCodeAt(0) - 65248)
  )
  // result => "-4", "20", "文字列"
  const number = Number(result) < 0 ? 0 : Number(result)
  return number
}

extend("remindDay", {
  validate(value) {
    return !isNaN(filter(value))
  },
  message: "入力形式が不適です"
})

extend("maxRemindDay", {
  validate(value) {
    if (filter(value) > 31) {
      return false
    }
    return true
  },
  message: "30日以下で設定してください"
})

export default {
  components: {
    ValidationProvider,
    ValidationObserver
  }
}
