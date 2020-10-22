<template>
  <div class="body">
    <el-container class="main">
      <el-header class="main-header">
        <div class="header-title">{{ surveyData.title }}</div>
      </el-header>
      <div class="header-desc">{{ surveyData.header_desc }}</div>
      <i class="cut-off" />
      <el-main class="main-content">
        <div class="issue" v-for="(item, index) in surveyData.detail" :key="index">
          <div :id="`item_${index}`" v-if="item.type === 'SingleChoice'">
            <div class="issue-header">
              {{ `${index + 1}.${item.title}&nbsp; &nbsp;` }}
              <span v-show="isFirst && verifyResult[index] === 0" style="color:red;">未填写</span>
            </div>
            <div class="issue-item" v-for="(_item, sonIndex) in item.choice_list" :key="sonIndex">
              <el-radio
                class="issue-radio"
                v-model="result[index].choice_list"
                :label="_item"
                @change="changeSinRadio(index)"
                >{{ _item }}</el-radio
              >
              <input v-if="_item === '其他'" v-model="result[index].elseCont" />
            </div>
          </div>
          <div :id="`item_${index}`" v-if="item.type === 'MultipleChoice'">
            <div class="issue-header">
              {{ `${index + 1}.${item.title}&nbsp;&nbsp;` }}
              <span class="choice-color" v-if="item.minChoice && item.minChoice">{{
                `(最少选择${item.minChoice}项，最多选择${item.maxChoice}项)&nbsp;`
              }}</span>
              <span v-show="isFirst && verifyResult[index] === 0" style="color:red;">未填写</span>
            </div>
            <div class="issue-item" v-for="(_item, sonIndex) in item.choice_list" :key="sonIndex">
              <el-checkbox
                class="issue-radio"
                v-model="result[index].choice_list"
                :label="_item"
                @change="changeMulBox(item, result[index].choice_list, index)"
                >{{ _item }}</el-checkbox
              >
              <input style="margin-left:30px;" v-if="_item === '其他'" v-model="result[index].elseCont" />
            </div>
          </div>
          <div :id="`item_${index}`" v-if="item.type === 'GapFilling'">
            <div class="issue-header">
              {{ `${index + 1}.${item.title}&nbsp; &nbsp;` }}
              <span v-show="isFirst && verifyResult[index] === 0" style="color:red;">未填写</span>
            </div>
            <div class="issue-item">
              <el-input
                type="textarea"
                :rows="2"
                placeholder="请输入内容"
                v-model="result[index].fillGap"
                @change="changeGapFill(index)"
              ></el-input>
            </div>
          </div>
          <div :id="`item_${index}`" v-if="item.type === 'SubQuestions'">
            <div class="issue-header">
              {{ `${index + 1}.${item.main_title}&nbsp; &nbsp;` }}
              <span v-show="isFirst && verifyResult[index] === 0" style="color:red;">有选项未填写</span>
            </div>
            <div class="issue-item" v-for="(_item, sonIndex) in item.vice" :key="sonIndex">
              <div v-if="_item.type === 'SingleChoice'">
                <div class="issue-header">
                  {{ `${index + 1}.${sonIndex + 1}.${_item.title}` }}
                  {{ index + sonIndex }}
                </div>
                <div class="issue-item" v-for="(__item, granIndex) in _item.choice_list" :key="granIndex">
                  <el-radio
                    class="issue-radio"
                    v-model="result[index].vice[sonIndex].choice_list"
                    :label="__item"
                    @change="changeSinRadio(index)"
                    >{{ __item }}</el-radio
                  >
                  <input v-if="__item === '其他'" v-model="result[index].vice[sonIndex].elseCont" />
                </div>
              </div>
              <div v-if="_item.type === 'MultipleChoice'">
                <div class="issue-header">
                  {{ `${index + 1}.${_item.title}&nbsp; &nbsp;` }}
                  <span class="choice-color" v-if="_item.minChoice && _item.minChoice">{{
                    `(最少选择${_item.minChoice}项，最多选择${_item.maxChoice}项)&nbsp;`
                  }}</span>
                </div>
                <div class="issue-item" v-for="(__item, granIndex) in _item.choice_list" :key="granIndex">
                  <el-checkbox
                    class="issue-radio"
                    v-model="result[index].vice[sonIndex].choice_list"
                    :label="__item"
                    @change="changeMulBox(_item, result[index].vice[sonIndex].choice_list, index, sonIndex)"
                    >{{ __item }}</el-checkbox
                  >
                  <input
                    style="margin-left:30px;"
                    v-if="__item === '其他'"
                    v-model="result[index].vice[sonIndex].elseCont"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </el-main>
      <el-footer class="main-footer">
        <div class="main-footer-text">{{ surveyData.footer_desc }}</div>
        <el-button type="primary" @click="emitSurvey">提交</el-button>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import surveyModel from '../../model/survey'
import { DeepClone } from '../../lin/util/common'

let surveyId = 1
let username = null
export default {
  name: 'fillsurvey',
  data() {
    return {
      surveyData: {},
      sinRadio: '1',
      elseCont: '', // 其他
      result: {}, // 存取结果
      verifyResult: [], // 验证是否都有填写
      isFirst: false, // 是否是第一次进入
      verifyMul: new Map(), // 验证多选
    }
  },
  methods: {
    // 单选触发事件
    changeSinRadio(e) {
      this.verifyResult.splice(e, 1, 1) // 如果填写了就标记1
    },
    // 多选选触发事件item.minChoice item.maxChoice
    changeMulBox(item, resultList, index, sonIndex) {
      this.getChoiceInfo(item.minChoice, item.maxChoice, resultList.length, index, sonIndex) // AOP拦截
      this.verifyResult.splice(index, 1, 1) // 如果填写了就标记1
    },
    // 填空触发事件
    changeGapFill(index) {
      if (this.result[index].fillGap === '') {
        this.verifyResult.splice(index, 1, 0)
      } else {
        this.verifyResult.splice(index, 1, 1)
      }
    },
    // 复制survey
    copySurvey(survey) {
      this.result = DeepClone(survey)
      this.result.forEach(item => {
        if (item.type === 'MultipleChoice') {
          item.choice_list = []
        }
        if (item.type === 'SubQuestions') {
          item.vice.forEach(_item => {
            if (_item.type === 'MultipleChoice') {
              _item.choice_list = []
            }
          })
        }
      })
      this.createVerifyArr()
    },
    // 验证是否都有填写
    verifyInFill() {
      for (let i = 0; i < this.verifyResult.length; i++) {
        if (!this.verifyResult[i]) {
          this.scrollView(i)
          return i
        }
      }
      return -1
    },
    // 创建验证数组
    createVerifyArr() {
      const len = this.result.length
      this.verifyResult = new Array(len)
      this.verifyResult.fill(0)
    },
    // 初始化验证 is_login, is_copy, limit_ip
    verifyInit(rule) {
      if (rule.is_login) {
        // 如果需要登录
        if (!this.$store.getters.logined) {
          this.$message({
            message: '本问卷要求登录，请先到登录页面登录！',
            type: 'warning',
          })
          setTimeout(() => {
            this.$router.push({
              path: '/login',
            })
          }, 1000)
        }
        username = this.$store.getters.user && this.$store.getters.user.nickname
      }
    },
    // 获取问卷信息
    getSurvey(id) {
      surveyModel.getSurvey(id).then(res => {
        if (res) {
          this.surveyData = res
          surveyId = res.id
          this.copySurvey(res.detail)
          this.verifyInit(res.detail_rule)
        } else {
          this.$message({
            message: '未获取到对应的问卷，将返回主页',
            type: 'warning',
          })
          this.$router.push({
            path: '/survey/list',
          })
        }
      })
    },
    // 获取问卷多选的限制信息
    getChoiceInfo(min = 0, max = 100, len, ...i) {
      const [index, sonIndex] = i
      if (sonIndex) {
        if (len >= min && len <= max) {
          this.verifyMul.set(index, { sonIndex: true })
        } else {
          this.verifyMul.set(index, { sonIndex: index })
        }
      } else if (len >= min && len <= max) {
        this.verifyMul.set(index, true)
      } else {
        this.verifyMul.set(index, index)
      }
    },
    // 验证
    verifyChoiceInfo() {
      for (const [key, value] of this.verifyMul) {
        if (value.sonIndex) {
          if (value.sonIndex !== true) {
            this.scrollView(key)
            return false
          }
        } else if (value !== true) {
          this.scrollView(key)
          return false
        }
      }
      return true
    },
    // 提交问卷
    emitSurvey() {
      // 看看是否有未填写的问卷
      if (this.verifyInFill() !== -1) {
        this.isFirst = true // 开启告警
        this.$message({
          message: '有未填写问卷，请填写完整再提交！',
          type: 'warning',
        })
        return
      }
      // 验证是否有未在限制内的多选题

      if (!this.verifyChoiceInfo()) {
        this.$message({
          message: '有多选题未按要求答题',
          type: 'warning',
        })
        return
      }
      surveyModel
        .fillSurvey(surveyId, username, this.result)
        .then(res => {
          if (res.code === 17) {
            this.$message({
              message: '恭喜你提交问卷成功',
              type: 'success',
            })
            this.$router.push({
              path: '/succeed',
            })
          }
        })
        .catch(err => {
          console.log(err)
        })
    },
    // 划屏操作
    scrollView(i) {
      document.getElementById(`item_${i}`).scrollIntoView({ behavior: 'smooth' })
    },
  },
  mounted() {
    const { id } = this.$route.params
    if (id) {
      this.getSurvey(id)
    } else {
      this.$message({
        message: '未获取到对应的问卷，将返回主页',
        type: 'warning',
      })
      this.$router.push({
        path: '/survey/list',
      })
    }
  },
}
</script>
<style lang="scss" scoped>
.body {
  width: 100%;
  height: 100%;
  background-color: rgb(245, 245, 245);
  position: absolute;
}

.cut-off {
  background-color: rgb(58, 115, 170);
  border-top: 2px solid rgba(0, 0, 0, 0.1);
}

.choice-color {
  color: #409eff;
}

.main {
  margin: 50px auto;
  padding: 50px;
  width: 80%;
  background-color: #fff;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  @include respond-to(lg) {
    margin: 10px auto;
    width: 100%;
    padding: 20px;
  }
  .main-header {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;

    .header-title {
      font-size: 18px;
      margin: 10px;
    }
  }

  .header-desc {
    margin: 10px;
    text-align: left;
  }

  .main-content {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-start;

    .issue {
      margin: 10px 0;

      .issue-header {
        display: flex;
        justify-content: flex-start;
        margin: 5px 0;
      }

      .issue-item {
        display: flex;
        justify-content: flex-start;
        align-items: center;
        padding: 5px;
      }
    }
  }

  .main-footer {
    .main-footer-text {
      margin: 10px 0 20px 0;
    }
  }
}
</style>
