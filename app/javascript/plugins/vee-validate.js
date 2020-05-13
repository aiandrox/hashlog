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

export default {
  components: {
    ValidationProvider,
    ValidationObserver
  }
}
