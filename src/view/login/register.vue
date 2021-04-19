<template>
  <div class="register">
    <div class="tiger" ref="tiger"></div>
    <el-form
      class="from"
      ref="form"
      status-icon
      label-position="right"
      :model="form"
      :rules="rules"
      hide-required-asterisk
    >
      <el-form-item label="用户名:" prop="username">
        <el-input clearable v-model="form.username" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="密码:" prop="password">
        <el-input clearable type="password" v-model="form.password" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="确认密码:" prop="confirm_password" autocomplete="off">
        <el-input clearable type="password" v-model="form.confirm_password"></el-input>
      </el-form-item>
      <el-form-item label="邮箱:" prop="email">
        <el-input clearable v-model="form.email" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="loading" @click="onRegister('form')">立即注册</el-button>
        <el-button @click="onCallback">取消</el-button>
      </el-form-item>
    </el-form>
    <div class="rabbit" ref="rabbit"></div>
  </div>
</template>

<script>
import lottie from 'lottie-web'
import Tiger from '@/assets/lottie/tigerhi.json'
import Rabbit from '@/assets/lottie/presto-rabbit.json'
import User from '@/lin/model/user'

export default {
  name: 'register',
  data() {
    // 验证回调函数
    const checkUserName = (rule, value, callback) => {
      // eslint-disable-line
      if (!value) {
        callback(new Error('用户名不能为空'))
      }
      callback()
    }
    const validatePassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入密码'))
      } else if (value.length < 6) {
        callback(new Error('密码长度不能少于6位数'))
      } else {
        if (this.form.checkPassword !== '') {
          this.$refs.form.validateField('confirm_password')
        }
        callback()
      }
    }
    const validatePassword2 = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.form.password) {
        callback(new Error('两次输入密码不一致!'))
      } else {
        callback()
      }
    }
    return {
      loading: false, // 加载动画
      form: {
        username: '',
        password: '',
        confirm_password: '',
        email: '',
      },
      rules: {
        username: [
          {
            validator: checkUserName,
            trigger: ['blur', 'change'],
            required: true,
          },
        ],
        password: [{ validator: validatePassword, trigger: 'blur', required: true }],
        confirm_password: [{ validator: validatePassword2, trigger: 'blur', required: true }],
        email: [
          {
            type: 'email',
            message: '请输入正确的邮箱地址',
            trigger: ['blur', 'change'],
            required: true,
          },
        ],
      },
    }
  },
  methods: {
    async onRegister(formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          // 新增用户
          try {
            this.loading = true
            const res = await User.userRegister(this.form)
            if (res.code < window.MAX_SUCCESS_CODE) {
              this.loading = false
              this.$message.success(`${res.message}`)
              this.eventBus.$emit('addUser', true)
              this.resetForm(formName)
            }
          } catch (e) {
            this.loading = false
            if (e.data.code === 10073 || e.data.code === 10071) {
              this.$message.error(e.data.message)
            } else {
              this.$message.error('新增用户失败')
            }
            console.log(e)
          }
        } else {
          console.log('error submit!!')
          this.$message.error('请填写正确的信息')
        }
      })
    },
    onCallback() {
      this.$router.go(-1)
    },
  },
  mounted() {
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
}
</script>

<style lang="scss" scoped>
.register {
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
  .rabbit {
    height: 500px;
    width: 500px;
    position: fixed;
    bottom: 0;
    @include respond-to(lg) {
      display: none;
    }
  }
  .from {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 445px;
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
