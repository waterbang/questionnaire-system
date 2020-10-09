const surveyRouter = {
  route: '/survey',
  name: Symbol('survey'),
  title: '问卷管理',
  type: 'view', // 类型: folder, tab, view
  icon: 'iconfont icon-moshubang',
  filePath: 'view/survey/survey-card.vue', // 文件路径
  inNav: true,
  // children: [
  //   {
  //     title: '问卷列表',
  //     type: 'view',
  //     name: 'SurveyCreate',
  //     route: '/survey/card',
  //     filePath: 'view/survey/survey-card.vue',
  //     inNav: true,
  //     icon: 'iconfont icon-gengduo',
  //   },
  //   {
  //     title: '添加问卷',
  //     type: 'view',
  //     name: 'SurveyCreate',
  //     route: '/survey/add',
  //     filePath: 'view/survey/survey-create.vue',
  //     inNav: true,
  //     icon: 'iconfont icon-tushuguanli',
  //   },
  //   {
  //     title: '编辑问卷',
  //     type: 'view',
  //     name: 'SurveyCreate',
  //     route: '/survey/edit',
  //     filePath: 'view/survey/survey-edit.vue',
  //     inNav: true,
  //     icon: 'iconfont icon-edit-square',
  //   },
  // ],
}

export default surveyRouter
