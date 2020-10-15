const surveyRouter = {
  route: null,
  name: null,
  title: '问卷管理',
  type: 'tab', // 类型: folder, tab, view
  icon: 'iconfont icon-moshubang',
  filePath: 'view/survey', // 文件路径
  inNav: true,
  children: [
    {
      title: '问卷列表',
      type: 'view',
      name: 'SurveyCreate',
      route: '/survey/list',
      filePath: 'view/survey/survey-card.vue',
      inNav: true,
      icon: 'iconfont icon-tushuguanli',
    },
    {
      route: '/survey/edit',
      name: 'SurveyCreate',
      title: '问卷创建',
      type: 'view', // 类型: folder, tab, view
      icon: null,
      filePath: 'view/survey/survey-edit.vue', // 文件路径
      inNav: false,
    },
    {
      route: '/survey/edit/:id',
      title: '问卷编辑',
      type: 'view',
      name: 'SurveyEdit',
      filePath: 'view/survey/survey-edit.vue',
      inNav: false,
      icon: 'iconfont icon-gengduo',
    },
  ],
}

export default surveyRouter
