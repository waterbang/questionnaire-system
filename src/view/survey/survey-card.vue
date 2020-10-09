<template>
  <div>
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="new-project">
          <el-button @click="onCreateProject" type="primary" icon="el-icon-plus">新建项目</el-button>
        </el-card>
      </el-col>
      <el-col :span="6" v-for="(item, index) in survey" :key="index">
        <suervey-item :survey="item" :index="index" @deleteItem="deleteItem"></suervey-item>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import suerveyItem from '../../component/suerveyItem/suerveyItem'
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
      this.$router.push({ name: 'editsurvey' })
    },
    // 删除项目
    deleteItem(e) {
      this.survey.splice(e, 1)
    },
  },
  mounted() {
    this._getSurveyList()
  },
  watch: {
    $route(to) {
      if (to.path === '/home') {
        window.location.reload()
      }
    },
  },
  components: {
    suerveyItem,
  },
}
</script>
<style lang="scss" scoped>
.new-project {
  margin-bottom: 10px;
  height: 200px;
  width: 300px;
  padding: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
