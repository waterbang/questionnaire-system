import * as type from './survey-mutation-type'

const surveyStore = {
  namespaced: true,
  store: {
    rule: {},
  },
  mutations: {
    [type.SET_SURVEY_RULE_MAX]() {},
    [type.SET_SURVEY_RULE_MIN]() {},
  },
  actions: {},
}

export default surveyStore
