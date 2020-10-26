<template>
  <div class="survey-card">
    <el-row :gutter="20">
      <el-col :span="span">
        <el-card class="new-project">
          <el-button @click="onCreateProject" type="primary" icon="el-icon-plus">新建项目</el-button>
        </el-card>
      </el-col>
      <el-col :span="span" v-for="(item, index) in survey" :key="index.id">
        <suervey-item
          :survey="item"
          :index="index"
          @deleteItem="deleteItem"
          @_getSurveyList="_getSurveyList"
        ></suervey-item>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import suerveyItem from './suervey-item/suervey-item'
import surveyModel from '@/model/survey'

let resizeFlag = null
export default {
  data() {
    return {
      survey: {},
      span: 6,
    }
  },
  methods: {
    // 获取列表
    _getSurveyList() {
      surveyModel.getSurveys().then(res => {
        this.survey = res.items
      })
    },
    // 创建项目
    onCreateProject() {
      this.$router.push({ path: '/survey/edit/' })
    },
    // 删除项目
    deleteItem(e) {
      this.survey.splice(e, 1)
    },
    // 挂载监听窗口方法
    _onresize() {
      window.onresize = () => {
        if (resizeFlag) {
          clearTimeout(resizeFlag)
        }
        resizeFlag = setTimeout(() => {
          this.setCardSize(document.body.clientWidth)
          resizeFlag = null
        }, 1000)
      }
    },
    setCardSize(clientWidth) {
      if (clientWidth < 1000 && clientWidth > 800) {
        this.span = 12
      } else if (clientWidth < 800) {
        this.span = 24
      } else {
        this.span = 6
      }
    },
  },
  mounted() {
    this._getSurveyList()
    this._onresize() // 监听窗口高度
    this.setCardSize(document.body.clientWidth) // 初始化窗口高度
  },
  components: {
    suerveyItem,
  },
}
</script>
<style lang="scss" scoped>
.survey-card {
  margin-left: 10px;
  .new-project {
    margin-bottom: 10px;
    height: 200px;
    width: 300px;
    padding: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
  }
}
</style>
