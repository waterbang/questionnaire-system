<template>
  <div class="content">
    <div class="content-text">问卷提交成功，感谢参与!</div>
    <el-button @click="backRoule">返回问卷调查系统</el-button>
  </div>
</template>

<script>
export default {
  methods: {
    backRoule() {
      this.$router.push({
        path: '/survey/list',
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.content {
  position: fixed;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  .content-text {
    margin-bottom: 20px;
  }
}
</style>
