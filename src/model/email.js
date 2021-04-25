// eslint-disable-next-line import/no-cycle
import { get } from '@/lin/plugin/axios'

class Email {
  async getEmailIsIlve() {
    return get('/cms/email/isActivate')
  }

  async activateEmail(code, user_id) {
    return get(`/cms/email/activateEmail?code=${code}&user_id=${user_id}`)
  }
}

export default new Email()
