<template>
  <div class="survey-card">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="new-project">
          <el-button @click="onCreateProject" type="primary" icon="el-icon-plus">新建项目</el-button>
        </el-card>
      </el-col>
      <el-col :span="6" v-for="(item, index) in survey" :key="index.id">
        <suervey-item :survey="item" :index="index" @deleteItem="deleteItem"></suervey-item>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import suerveyItem from './suerveyItem/suerveyItem'
import surveyModel from '@/model/survey'

export default {
  data() {
    return {
      survey: {},
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
  },
  mounted() {
    this._getSurveyList()
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
