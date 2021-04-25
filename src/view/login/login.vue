<template>
  <div class="login">
    <div class="tiger" ref="tiger"></div>
    <div class="rabbit" ref="rabbit"></div>
    <div class="form-box" v-loading="loading" element-loading-background="rgba(0, 0, 0, 0)">
      <div class="title">
        <h1 title="Lin">玉米问卷调查系统</h1>
      </div>
      <form class="login-form" autocomplete="off">
        <div class="form-item">
          <span class="icon account-icon"></span>
          <el-input type="text" v-model="form.username" autocomplete="off" placeholder="请填写用户名" />
        </div>
        <div class="form-item">
          <span class="icon secret-icon"></span>
          <el-input type="password" v-model="form.password" autocomplete="off" placeholder="请填写用户登录密码" />
        </div>
        <div class="button-submit">
          <button class="submit-btn black" @click="throttleLogin">登录</button>
          <button class="submit-btn regist" @click="register">注册</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapMutations } from 'vuex'
import lottie from 'lottie-web'
import User from '@/lin/model/user'
import Utils from '@/lin/util/util'
import Rabbit from '@/assets/lottie/presto-rabbit.json'
import Tiger from '@/assets/lottie/tigerhi.json'

export default {
  name: 'login',
  data() {
    return {
      loading: false, // 加载动画
      wait: 2000, // 2000ms之内不能重复发起请求
      throttleLogin: null, // 节流登录
      form: {
        username: '',
        password: '',
      },
    }
  },
  methods: {
    async login() {
      const { username, password } = this.form
      try {
        this.loading = true
        await User.getToken(username, password)
        await this.getInformation()
        this.loading = false
      } catch (e) {
        this.loading = false
      }
    },
    async getInformation() {
      try {
        // 尝试获取当前用户信息
        const user = await User.getPermissions()
        this.setUserAndState(user)
        this.setUserPermissions(user.permissions)
        const islive = await this.$store.dispatch('setEmailLiveState')
        if (islive) {
          this.$message.success('登录成功')
          this.$router.push('/about')
        } else {
          this.$router.push('/checkCode')
          this.$notify({
            title: '邮箱未激活',
            message: '您邮箱未激活,请先激活再登录哟',
          })
        }
      } catch (e) {
        console.log(e)
      }
    },
    ...mapActions(['setUserAndState']),
    ...mapMutations({
      setUserPermissions: 'SET_USER_PERMISSIONS',
    }),
    register() {
      this.$router.push({ name: 'register' }).catch(e => {
        console.log(e)
        this.$router.push({ name: 'register' })
      })
    },
    initLottie() {
      lottie.loadAnimation({
        container: this.$refs.tiger, // 包含动画的dom元素
        renderer: 'svg', // 渲染出来的是什么格式
        loop: true, // 循环播放
        autoplay: true, // 自动播放
        animationData: Tiger, // 动画json的路径
      })
      lottie.loadAnimation({
        container: this.$refs.rabbit, // 包含动画的dom元素
        renderer: 'svg', // 渲染出来的是什么格式
        loop: true, // 循环播放
        autoplay: true, // 自动播放
        animationData: Rabbit, // 动画json的路径
      })
      lottie.play()
    },
  },
  mounted() {
    this.initLottie()
  },
  created() {
    // 节流登录
    this.throttleLogin = Utils.throttle(this.login, this.wait)
  },
  components: {},
}
</script>

<style lang="scss">
.login {
  .tiger {
    position: fixed;
    left: -10%;
    top: 0;
    @include respond-to(lg) {
      display: none;
    }
  }
  .rabbit {
    width: 200px;
    height: 200px;
    position: fixed;
    left: 64%;
    top: 4%;
    @include respond-to(lg) {
      left: 20%;
      top: -10%;
    }
  }
  .form-box {
    position: fixed;
    left: 70%;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 445px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    padding: 3rem;
    background-color: #ffffff;
    z-index: 1;
    @include respond-to(lg) {
      left: 50%;
      width: 90%;
    }
    .title {
      height: 37px;
      font-size: 30px;
      line-height: 37px;
      margin-bottom: 15%;

      h1 {
        padding-left: 74px;
        box-sizing: border-box;
        text-align: left;
        @include respond-to(lg) {
          padding-left: 0;
          text-align: center;
        }
      }
    }

    .login-form {
      width: 100%;
      .form-item {
        width: 100%;
        box-sizing: border-box;
        padding-bottom: 13px;
        margin-bottom: 34px;
      }

      .button-submit {
        display: flex;
        justify-content: space-around;
        align-items: center;
        .submit-btn {
          border-radius: 10px;
          width: 30%;
          height: 50px;
          font-size: 16px;
          text-align: center;
          box-sizing: border-box;
          padding: 0 10px;
          border: none;
          cursor: pointer;
        }
        .black {
          background-color: #ea8850;
        }
        .regist {
          background-color: #e5e5e5;
        }
      }
    }
  }
}
</style>
