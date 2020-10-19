import _axios, { get, put, _delete } from '@/lin/plugin/axios'

class Survey {
  async createSurvey(data) {
    return _axios({
      method: 'post',
      url: 'v1/survey',
      data,
    })
  }

  async getSurvey(id) {
    const res = await get(`v1/survey/${id}`)
    return res
  }

  async getSurveys(page = 0, count = 10) {
    return _axios({
      method: 'get',
      url: `v1/survey?page=${page}&count=${count}`,
      heandleError: true,
    })
  }

  async deleteSurvey(id) {
    const res = await _delete(`v1/survey/${id}`)
    return res
  }

  async editSurvey(id, info) {
    const res = await put(`v1/survey/${id}`, info)
    return res
  }

  // 发布问卷
  async putSendSurvey(id) {
    const res = await put(`/v1/survey/update/status/${id}`, {
      status: 2,
      id,
    })
    return res
  }
}

export default new Survey()
