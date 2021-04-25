import { get } from '@/lin/plugin/axios'

class User {
  getUserAbout() {
    return get('/cms/user/getAbout')
  }
}

export default new User()
