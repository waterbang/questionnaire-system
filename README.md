## 问卷调查系统
master分支是前台，koa分支是后端，cms分支是后台管理端。

### 1. 文件目录及说明
+ backend  后端代码 使用python flask搭建的服务器
	+ application	包含后端接口路由配置，访问MySQL数据库配置及模型
		get_data.py	从MySQL中获取问卷数据
		models.py	ORM数据库模型
		routes.py	后端路由配置
		save_data.py 访问并存储数据到数据库
	run.py	使用命令 python3 run.py启动服务，开启后端接口以及读取dist文件下的资源渲染前端页面
	config.py	SQLALchemy及Flask环境变量设置
+ dist	npm build生成的静态资源文件夹
+ frontend 前端代码 使用Vue-cl 通信模块axios；UI使用Element UI
	+ src
		+ components
			+ AnswerSurvey
				SurveyList.vue	问卷列表组件
			+ FillingSurvey  **填写问卷**填写问卷包含的组件
				MultipleChoiceFilling.vue 多选题问卷页面组件
				SingleChoiceFilling.vue  单选题问卷页面组件
			+ QuestionTemplates	**制作问卷**页面包含的组件
				FillingBlank.vue	填空题组件
				MultipleChoice.vue	多选题组件
				SingleChoice.vue	单选题组件
				NewSingleChoice.vue	无用

### 2. 网站结构
目前包含问卷编辑问卷列表信息以及填写问卷页面
- 问卷编辑页面可用于制作问卷、保存问卷到数据库
- 问卷列表 查看当前数据库中已有的列表
- 填写问卷 填写问卷并提交到数据库

### 3. 待更新内容：
- 填写问卷目前从问卷列表栏目进入，应当直接在问卷列表下更新视图。因此需要移动“填写问卷”视图到问卷列表中
- 填写问卷页面需要重新排版
