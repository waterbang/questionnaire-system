import appConfig from '@/config/index'
import Util from '@/lin/util/util'
import Vue from 'vue'
import Router from 'vue-router'
import store from '../store'
import routes from './route'

Vue.use(Router)

// 判断是否需要登录访问, 配置位于 config 文件夹
let isLoginRequired = routeName => {
  // 首次执行时缓存配置
  let { notLoginRoute } = appConfig
  const notLoginMark = {}

  // 构建标记对象
  if (Array.isArray(notLoginRoute)) {
    for (let i = 0; i < notLoginRoute.length; i += 1) {
      notLoginMark[notLoginRoute[i].toString()] = true
    }
  }

  notLoginRoute = null // 释放内存

  // 重写初始化函数
  isLoginRequired = name => {
    if (!name) {
      return true
    }
    // 处理 Symbol 类型
    const target = typeof name === 'symbol' ? name.description : name
    return !notLoginMark[target]
  }

  return isLoginRequired(routeName)
}

const router = new Router({
  // mode: 'history',
  scrollBehavior: () => ({
    y: 0,
  }),
  base: process.env.BASE_URL,
  routes,
})

router.beforeEach((to, from, next) => {
  // 登录验证
  if (isLoginRequired(to.name) && !store.state.logined) {
    next({ path: '/login' })
    return
  }
  if (isLoginRequired(to.name) && store.state.logined && !store.state.isLive) {
    Vue.prototype.$notify({
      title: '邮箱未激活📮',
      dangerouslyUseHTMLString: true,
      message: '<strong class="my-notify">您邮箱未激活,请先激活再登录哟</strong>',
    })
    next({ path: '/checkCode' })
    return
  }

  // TODO: tab 模式重复点击验证

  // 权限验证
  if (store && store.state && store.getters) {
    const { permissions, user } = store.getters
    if (to.path !== '/about' && !Util.hasPermission(permissions, to.meta, user)) {
      Vue.prototype.$notify({
        title: '无权限',
        dangerouslyUseHTMLString: true,
        message: '<strong class="my-notify">您无此页面的权限哟</strong>',
      })
      next({ path: '/about' })
      return
    }
  }

  // 路由发生变化重新计时
  Vue.prototype.$_lin_jump()

  // 路由发生变化修改页面title
  if (to.meta.title) {
    document.title = to.meta.title
  }

  next()
})

export default router
