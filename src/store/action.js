import { removeToken } from '@/lin/util/token'
// eslint-disable-next-line import/no-cycle
import Email from '../model/email'
import * as types from './mutation-type'

export default {
  setUserAndState({ commit }, user) {
    // 如果登陆成功，设置logined标志位
    commit(types.SET_LOGINED, true)
    // 设置全局用户状态
    commit(types.SET_USER, user)
  },

  async setEmailLiveState({ commit }) {
    const user = await Email.getEmailIsIlve()
    commit(types.SET_EMAIL_LIVE)
    return user.islive
  },

  loginOut({ commit }) {
    removeToken()
    commit(types.REMOVE_LOGINED, false)
  },

  readMessage({ commit }, message) {
    commit(types.REMOVE_UNREAD_MESSAGE, message.id)
    commit(types.ADD_READED_MESSAGE, message)
  },
}
