<template>
  <div class="checkCode">
    <div class="tiger" ref="tiger"></div>
    <div class="from">
      <h2>{{ title }}</h2>
      <el-button type="primary" :loading="loading" @click="goAbout">立即登录</el-button>
    </div>
  </div>
</template>

<script>
import lottie from 'lottie-web'
import Tiger from '@/assets/lottie/tigerhi.json'

export default {
  name: 'checkCode',
  data() {
    return {
      loading: false, // 加载动画
      title: '📮邮箱验证成功，正在自动登录',
    }
  },
  methods: {
    goAbout() {
      this.$router.push({ path: '/about' })
    },
    initLottie() {
      lottie.loadAnimation({
        container: this.$refs.tiger, // 包含动画的dom元素
        renderer: 'svg', // 渲染出来的是什么格式
        loop: true, // 循环播放
        autoplay: true, // 自动播放
        animationData: Tiger, // 动画json的路径
      })
      lottie.play()
    },
  },
  mounted() {
    this.initLottie()
  },
}
</script>

<style lang="scss" scoped>
.checkCode {
  .tiger {
    width: 300px;
    height: 300px;
    position: fixed;
    top: 13%;
    left: 50%;
    transform: translate(-50%, -50%);
    @include respond-to(lg) {
    }
  }
  .from {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 445px;
    height: 500px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 1rem;
    margin: 1rem;
    background-color: #ffffff;
    z-index: 1;
    @include respond-to(lg) {
      width: 70%;
      height: 500px;
      left: 47%;
    }
  }
}
</style>
