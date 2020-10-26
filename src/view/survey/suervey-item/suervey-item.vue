<template>
  <div>
    <el-card class="_card" @mouseout.native="onMouseover(true)" @mouseover.native="onMouseover(false)">
      <div slot="header" class="clearfix">
        <span class="title">{{ survey.title }}</span>
        <el-tag class="tag" size="small">问卷</el-tag>
      </div>
      <div class="content">
        <el-tag class="tag" :type="tagColor" effect="plain" size="mini">{{
          survey.status === 1 ? '未发布' : '已发布'
        }}</el-tag>
        <div class="bottom">
          <div class="notTouch" v-show="this.isShow">
            <span class="dataNum">0 份数据</span>
            <span class="time">{{ HowLongWillThe }}</span>
          </div>
          <div class="Touch" v-show="!this.isShow">
            <i class="el-icon-edit" @click="editSuervey">修改</i>
            <i class="el-icon-s-promotion" @click="releaseTheQue">发布</i>
            <i class="el-icon-s-marketing" @click="gatherInfo">数据</i>
            <el-dropdown trigger="click" placement="bottom" size="mini">
              <i class="el-icon-more el-dropdown-link"></i>
              <el-dropdown-menu slot="dropdown" class="el-icon-arrow-down">
                <el-dropdown-item @click.native="deleteItem(survey.id)">删除</el-dropdown-item>
                <el-dropdown-item @click.native="copySurvey" :disabled="is_copy">复制问卷</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>
<script>
import surveyModel from '../../../model/survey'

export default {
  props: {
    survey: Object, // 存放数据
    index: Number, // 索引
  },
  computed: {
    // 显示多久时间
    HowLongWillThe() {
      const oldTime = Date.parse(this.survey.create_time)
      const Today = Date.parse(new Date())
      let s = Math.abs(Today - oldTime) / 1000
      // 秒数除以一天的毫秒数,就得到了天数
      const days = Math.floor(s / (24 * 3600))
      s %= 3600 * 24
      let hours = Math.floor(s / 3600)
      if (hours < 10) {
        hours = `0${hours}`
      }
      s %= 3600
      let minutes = Math.floor(s / 60)
      if (minutes < 10) {
        minutes = `0${minutes}`
      }
      s %= 60
      if (s < 10) {
        s = `0${s}`
      }
      return `${days}天${hours}小时${minutes}分钟`
    },
    tagColor() {
      // 给个颜色
      return this.survey.status === 1 ? 'warning' : 'success'
    },
    is_copy() {
      return !this.survey.rule.is_copy
    },
  },
  data() {
    return {
      isShow: true, // 标记是否移动到元素上
    }
  },
  methods: {
    onMouseover(flag) {
      // 显示与隐藏
      this.isShow = flag
    },
    // 前往调查统计
    gatherInfo() {
      if (this.survey.status !== window.SURVEYPULISH) {
        this.$message({
          message: '没有发布的问卷无法查看统计数据⛱️',
          type: 'warning',
        })
        return
      }
      this.$router.push({
        path: `/survey/gatherInfo/${this.survey.id}`,
      })
    },
    // 发布问卷
    releaseTheQue() {
      if (this.survey.status === window.SURVEYEDIT) {
        // 如果未发布
        surveyModel
          .putSendSurvey(this.survey.id)
          .then(res => {
            if (res.code === 16) {
              // 发布问卷成功
              this.$message({
                message: res.message,
                type: 'success',
              })
              this.$router.push({
                path: `/fillsurvey/${this.survey.id}`,
              })
            }
          })
          .catch(err => {
            this.$message.error(err.message)
          })
      } else {
        this.$router.push({
          path: `/fillsurvey/${this.survey.id}`,
        })
      }
    },
    // 编辑问卷
    editSuervey() {
      if (this.survey.status === window.SURVEYPULISH) {
        this.$message({
          message: '已经发布的问卷不能更改！',
          type: 'warning',
        })
        return
      }
      this.$router.push({
        path: `/survey/edit/${this.survey.id}`,
      })
    },
    deleteItem(id) {
      surveyModel.deleteSurvey(id).then(res => {
        if (res.code === 14) {
          this.$notify({
            title: '删除成功',
            message: res.message,
            type: 'success',
          })
          this.$emit('deleteItem', this.index)
        } else {
          this.$notify.error({
            title: '发生错误',
            message: res.message,
          })
        }
      })
    },
    copySurvey() {
      this.survey.title = `${this.survey.title}(副本)`
      surveyModel.createSurvey(this.survey).then(res => {
        if (res.code === 12) {
          this.$notify({
            title: '复制成功',
            message: '恭喜你复制问卷成功',
            type: 'success',
          })
          this.$emit('_getSurveyList')
        }
      })
    },
  },
}
</script>

<style scoped lang="scss" rel="stylesheet/stylus">
._card {
  margin-bottom: 10px;
  height: 200px;
  width: 300px;
  padding: 10px;

  .clearfix {
    height: 20px;
    width: 100%;
    display: flex;
    flex-direction: row;
    justify-content: space-between;

    .title {
      text-align: left;
      width: 250px;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
    }
  }

  .content {
    height: 115px;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;

    .tag {
      width: 50px;
    }

    .bottom {
      margin-top: auto;

      .notTouch {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        font-weight: 400;
        color: #7b7b7b;
        font-size: 12px;
      }

      .Touch {
        margin-right: 0;
        display: flex;
        justify-content: space-around;

        > i {
          cursor: pointer;
        }

        .el-dropdown-link {
          cursor: pointer;
          color: #409eff;
        }

        .el-icon-arrow-down {
          font-size: 12px;
        }
      }
    }
  }
}
</style>
