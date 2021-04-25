<template>
  <div class="checkCode">
    <div class="tiger" ref="tiger"></div>
    <div class="from" v-if="IsActivate">
      <h2 class="title">📮邮箱验证成功，正在自动登录</h2>
      <el-button type="primary" :loading="loading" @click="goAbout">立即登录</el-button>
    </div>
    <div class="from" v-else>
      <h2 class="title1">请登录您注册的邮箱，点击激活账号的链接</h2>
      <h4 class="title1">{{ myEmail }}</h4>
      <h5 class="title2">（如果没有请检查垃圾箱</h5>
      <div class="buttons">
        <el-button type="primary" :loading="loading" @click="goEmailAddress('https://www.google.com/gmail/about/')"
          >Google Email</el-button
        >
        <el-button type="primary" :loading="loading" @click="goEmailAddress('https://mail.163.com/')"
          >163 邮箱</el-button
        >
        <el-button type="primary" :loading="loading" @click="goEmailAddress('https://mail.qq.com/')">QQ 邮箱</el-button>
        <el-button type="primary" :loading="loading" @click="goEmailAddress('https://mail.126.com/?dv=pc')"
          >126 邮箱</el-button
        >
        <el-button type="primary" :loading="loading" @click="goEmailAddress('http://mail.yahoo.com')"
          >Yahoo! Mail</el-button
        >
        <el-button type="primary" :loading="loading" @click="goEmailAddress('https://outlook.live.com/owa/')"
          >outlook</el-button
        >
      </div>
    </div>
  </div>
</template>

<script>
import lottie from 'lottie-web'
import Tiger from '@/assets/lottie/tigerhi.json'
import Email from '../../model/email'

export default {
  name: 'checkCode',
  data() {
    return {
      loading: false, // 加载动画
      IsActivate: false, // 邮箱是否激活
      again: true, // 是否需要重新激活
      myEmail: this.$store.state.user.email,
    }
  },
  methods: {
    goAbout() {
      this.$router.push({ path: '/about' })
    },
    goEmailAddress(url) {
      window.location.href = url
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
    async isLiveEmail() {
      const islive = await this.$store.dispatch('setEmailLiveState')
      if (islive) {
        this.IsActivate = true
        this.$router.push('/about')
        return
      }
      this.IsActivate = false
    },
    async activateEmail() {
      const { code, user_id } = this.$route.query
      if (!code) {
        return
      }
      const live = await Email.activateEmail(code, user_id)
      this.$message.success(`${live.message}`)
      if (live.code === 20) {
        this.$router.push('/about')
      }
    },
  },
  mounted() {
    this.initLottie()
    this.activateEmail()
  },
  created() {
    this.isLiveEmail()
  },
}
</script>

<style lang="scss" scoped>
.checkCode {
  .tiger {
    width: 300px;
    height: 300px;
    position: fixed;
    top: 16%;
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
    height: 460px;
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
    .title1 {
      text-align: center;
      margin-bottom: 10px;
    }
    .title2 {
      text-align: center;
      color: rgb(165, 161, 161);
      margin-bottom: 60px;
    }
    .buttons {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      button {
        margin-bottom: 10px;
      }
    }
  }
}
</style>
