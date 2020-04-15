<template>
  <div>{{ user.name }} （@{{ user.screen_name }}）</div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      default: () => {},
    },
  },
};
</script>
