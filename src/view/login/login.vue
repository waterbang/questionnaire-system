<template>
  <div class="login">
    <div class="team-name hidden-sm-and-down">
      <img src="@/assets/image/login/team-name.png" alt="logo" />
    </div>
    <div class="form-box" v-loading="loading" element-loading-background="rgba(0, 0, 0, 0)">
      <div class="title">
        <h1 title="Lin">玉米问卷调查系统</h1>
      </div>
      <form class="login-form" autocomplete="off" @submit.prevent="throttleLogin()">
        <div class="form-item nickname">
          <span class="icon account-icon"></span>
          <input type="text" v-model="form.username" autocomplete="off" placeholder="请填写用户名" />
        </div>
        <div class="form-item password">
          <span class="icon secret-icon"></span>
          <input type="password" v-model="form.password" autocomplete="off" placeholder="请填写用户登录密码" />
        </div>
        <div class="button-submit">
          <button class="submit-btn black" type="submit">登录</button>
          <button class="submit-btn regist">注册</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions, mapMutations } from 'vuex'
import User from '@/lin/model/user'
import Utils from '@/lin/util/util'

export default {
  name: 'login',
  data() {
    return {
      loading: false, // 加载动画
      wait: 2000, // 2000ms之内不能重复发起请求
      throttleLogin: null, // 节流登录
      form: {
        username: 'root',
        password: '123456',
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
        this.$router.push('/about')
        this.$message.success('登录成功')
      } catch (e) {
        this.loading = false
        console.log(e)
      }
    },
    async getInformation() {
      try {
        // 尝试获取当前用户信息
        const user = await User.getPermissions()
        this.setUserAndState(user)
        this.setUserPermissions(user.permissions)
      } catch (e) {
        console.log(e)
      }
    },
    ...mapActions(['setUserAndState']),
    ...mapMutations({
      setUserPermissions: 'SET_USER_PERMISSIONS',
    }),
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
  width: 100%;
  height: 100%;
  background: url('../../assets/image/login/login-bg.jpg');
  background-size: 100% 100%;
  background-position: center center;
  overflow: auto;
  @include respond-to(lg) {
    background: url('../../assets/image/login/login-bg-iphone.jpg');
  }
  .team-name {
    position: fixed;
    left: 100px;
    top: 50%;
    width: 550px;
    transform: translateY(-50%);
  }

  .form-box {
    position: fixed;
    left: 70%;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 445px;
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
        color: #ffffff;
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
        height: 40px;
        box-sizing: border-box;
        padding-bottom: 13px;
        margin-bottom: 34px;

        input {
          width: 100%;
          height: 100%;
          background: transparent;
          color: #ffffff;
          font-size: 14px;
          box-sizing: border-box;
          border-bottom: 1px solid #dae1ed;
        }
      }

      .form-item.nickname {
        // background: url('../../assets/image/login/nickname.png') no-repeat;
        background-size: 100% auto;
        background-position: left bottom;
      }

      .form-item.password {
        // background: url('../../assets/image/login/password.png') no-repeat;
        background-size: 100% auto;
        background-position: left bottom;
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
          // background-color: #4d80e6;
        }
        .regist {
          // background-color: #008080;
        }
      }
    }
  }
}
</style>
