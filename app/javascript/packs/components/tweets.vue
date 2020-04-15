<template>
  <div>aaa</div>
</template>
<style scoped></style>
<script>
export default {
  data: function() {
    return {
      tag: {},
      tweets: [],
    };
  },

  created: function() {
    this.fetchData();
  },

  methods: {
    fetchData() {
      Axios.get("/api/v1/mypage/tweets.json").then((response) => {
        const responseData = response.data;
        this.user = responseData.user;
        this.tags = responseData.tags;
      });
    },
  },
};
</script>
