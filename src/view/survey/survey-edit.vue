<template>
  <div>
    <el-container>
      <el-container class="edit-main">
        <el-main class="questionnaire-list">
          <div class="header-content">
            <div class="header-title">
              <div @click="showHeader(false)">
                <span>问卷标题：</span>
                <span v-show="editHeader">{{ surveyData.title }}</span>
              </div>
              <el-input
                style="width:70%;"
                type="text"
                v-show="!editHeader"
                v-model="surveyData.title"
                placeholder="请输入您的问卷标题"
                @change="showHeader(true)"
              />
            </div>
            <div class="header-desc">
              <div @click="showDesc(false)">
                <span>问卷描述：</span>
                <span v-show="isdesc">{{ surveyData.header_desc }}</span>
              </div>
              <el-input
                style="width:70%;"
                type="textarea"
                v-show="!isdesc"
                v-model="surveyData.header_desc"
                :autosize="{ minRows: 2, maxRows: 4 }"
                placeholder="请输入您的问卷描述"
                @change="showDesc(true)"
              />
            </div>
          </div>
          <!-- 复制的表格 -->
          <div class="quest-main">
            <vuedraggable
              class="draggable"
              v-if="surveyData.detail.length"
              :list="surveyData.detail"
              group="_data"
              :options="{ handle: '.handle' }"
            >
              <div class="copy-data" v-for="(element, elIndex) in surveyData.detail" :key="elIndex">
                <!-- 单选 -->
                <div class="data-item" v-if="element.type === 'SingleChoice'">
                  <single-Multiple
                    :element="element"
                    :elIndex="elIndex"
                    @addOption="addOption"
                    @addElse="addElse"
                    @deleteItem="deleteItem"
                    @deleteOption="deleteOption"
                  ></single-Multiple>
                </div>
                <!-- 多选 -->
                <div class="data-item" v-if="element.type === 'MultipleChoice'">
                  <single-Multiple
                    :element="element"
                    :elIndex="elIndex"
                    :more="true"
                    @addOption="addOption"
                    @addElse="addElse"
                    @deleteItem="deleteItem"
                    @deleteOption="deleteOption"
                  ></single-Multiple>
                </div>
                <!-- 填空 -->
                <div class="data-item" v-if="element.type === 'GapFilling'">
                  <div class="item-single-title">
                    <div class="single-title" v-show="editHeader" @click="showHeader(false)">{{ element.title }}</div>
                    <el-input
                      style="width:50%; float: left;"
                      type="text"
                      v-show="!editHeader"
                      v-model="element.title"
                      placeholder="请输入您的问卷标题"
                      @blur="showHeader(true)"
                      @change="showHeader(true)"
                    />
                    <div class="single-delete">
                      <i class="el-icon-rank handle"></i>
                      <i class="el-icon-delete" @click="deleteItem(elIndex)"></i>
                    </div>
                  </div>
                  <div class="Gap-content">
                    <el-input
                      type="textarea"
                      :rows="2"
                      placeholder="请输入内容"
                      v-model="element.fillGap"
                      disabled
                    ></el-input>
                  </div>
                </div>
                <!-- 含子选择题 -->
                <div class="data-item" v-if="element.type === 'SubQuestions'">
                  <div class="item-single-title">
                    <div class="single-title" v-show="showSub" @click="showSubQuestions(false)">
                      {{ element.main_title }}
                    </div>
                    <el-input
                      style="width:50%; float: left;"
                      type="text"
                      v-show="!showSub"
                      v-model="element.main_title"
                      placeholder="请输入您的问卷标题"
                      @change="showSubQuestions(true)"
                    />
                    <div class="single-delete">
                      <i class="el-icon-rank handle"></i>
                      <i class="el-icon-delete" @click="deleteItem(elIndex)"></i>
                    </div>
                  </div>
                  <div @click="showSubQuestions(false)" v-for="(e, index) in element.vice" :key="index">
                    <single-Multiple
                      :sonIndex="index"
                      :element="e"
                      :elIndex="elIndex"
                      @addOption="addOption"
                      @addElse="addElse"
                      @deleteItem="deleteItem"
                      @deleteOption="deleteOption"
                    ></single-Multiple>
                  </div>
                  <div class="sub-add">
                    <el-button type="primary" icon="el-icon-plus" plain @click="addSub(elIndex, false)"
                      >增加单选</el-button
                    >
                    <el-button type="primary" icon="el-icon-plus" plain @click="addSub(elIndex, true)"
                      >增加多选</el-button
                    >
                  </div>
                </div>
              </div>
            </vuedraggable>
            <div class="text-centre" v-if="!surveyData.detail.length">
              <i class="el-icon-plus"></i>将右边的题目拖到此处
            </div>
          </div>
          <el-footer class="edit-footer">
            <div class="footer-end">
              <div>问卷结尾：</div>
              <el-input
                style="width:70%;"
                type="text"
                placeholder="请输入问卷结尾"
                v-model="surveyData.footer_desc"
              ></el-input>
            </div>
            <el-button :disabled="surStatus" type="primary" @click="sendData">{{
              isEdit ? '创建问卷' : '修改问卷'
            }}</el-button>
          </el-footer>
        </el-main>
      </el-container>
      <!--  候选题型 -->
      <topic @cloneData="cloneData"></topic>
    </el-container>
  </div>
</template>

<script>
import vuedraggable from 'vuedraggable'

import surveyModel from '../../model/survey'
import singleMultiple from './singleOrMultiple/singleOrMultiple'
import topic from './topic/topic'
import { _loading, DeepClone } from '../../lin/util/common'

export default {
  name: 'EditSurvey',
  inject: ['eventBus'],
  data() {
    return {
      question_list: ['SingleChoice'],
      id: null, // id
      surveyData: {
        title: '这里是默认的问卷标题',
        header_desc: '这里是问卷描述',
        detail: [
          {
            choice_list: ['选项一', '选项二'],
            title: '请从下面选择一个选项',
            type: 'SingleChoice',
          },
          {
            choice_list: ['选项一', '选项二'],
            title: '请从下面选择多个选项',
            type: 'MultipleChoice',
          },
        ],
        footer_desc: '您已完成本次问卷，感谢您的帮助与支持',
      },
      editHeader: true, // 是否点击到
      showSub: true, // 是否点击到subQuestions
      surStatus: false, // 是否能修改
      isEdit: false, // 是否是修改
      isdesc: true, // 是否点击到问卷描述
    }
  },
  methods: {
    // 切换heade
    showHeader(flag) {
      this.editHeader = flag
    },
    // 切换问卷描述
    showDesc(flag) {
      this.isdesc = flag
    },
    // 切换子选项
    showSubQuestions(flag) {
      this.showSub = flag
    },
    // 深度克隆数据防止重用
    cloneData(data) {
      const item = DeepClone(data)
      this.surveyData.detail.push(item)
    },
    // 添加单选或多选
    addSub(index, flag) {
      if (flag) {
        this.surveyData.detail[index].vice.push({
          choice_list: ['', ''],
          title: '请从下面选择多个选项',
          type: 'MultipleChoice',
        })
      } else {
        this.surveyData.detail[index].vice.push({
          choice_list: ['', ''],
          title: '请从下面选择一个选项',
          type: 'SingleChoice',
        })
      }
    },
    // 添加选项
    addOption(index, sonIndex) {
      if (this.surveyData.detail[index].type === 'SubQuestions') {
        this.surveyData.detail[index].vice[sonIndex].choice_list.push('')
      } else {
        this.surveyData.detail[index].choice_list.push('')
      }
    },
    // 添加其他选项
    addElse(index, sonIndex) {
      if (this.surveyData.detail[index].type === 'SubQuestions') {
        this.surveyData.detail[index].vice[sonIndex].choice_list.push('其他')
      } else {
        this.surveyData.detail[index].choice_list.push('其他')
      }
    },
    // 删除选项
    deleteOption(index, opIndex, sonIndex) {
      if (this.surveyData.detail[index].type === 'SubQuestions') {
        this.surveyData.detail[index].vice[sonIndex].choice_list.splice(opIndex, 1)
      } else {
        this.surveyData.detail[index].choice_list.splice(opIndex, 1)
      }
    },
    // 删除题目
    deleteItem(index, sonIndex) {
      if (sonIndex !== undefined) {
        // 删除子项
        this.surveyData.detail[index].vice.splice(sonIndex, 1)
      } else {
        this.surveyData.detail.splice(index, 1)
      }
    },
    // 发送请求
    sendData() {
      if (this.isEdit) {
        this.createData()
      } else {
        this.editData()
      }
    },
    // 创建问卷
    createData() {
      surveyModel
        .createSurvey(this.surveyData)
        .then(res => {
          if (res.code === 12) {
            this.$notify({
              title: '创建成功',
              message: '恭喜你创建问卷成功',
              type: 'success',
            })
            this.$router.replace({
              path: '/survey/list',
            })
          }
        })
        .catch(err => {
          console.log(err)
        })
    },
    // 编辑问卷
    async editData() {
      await surveyModel
        .editSurvey(this.id, this.surveyData)
        .then(res => {
          if (res.code === 13) {
            this.$notify({
              title: '修改成功',
              message: '恭喜你修改问卷成功',
              type: 'success',
            })
            this.$router.replace({
              path: '/survey/list',
            })
          }
        })
        .catch(err => {
          console.log(err)
        })
    },
    editSuervey(id) {
      // 导入编辑数据
      _loading(this, '获取问卷信息')
      surveyModel
        .getSurvey(id)
        .then(res => {
          if (res.status === window.SURVEYPULISH) {
            // 判断是否已发布
            this.surStatus = true
          }
          this.surveyData = res
          this.id = res.id
        })
        .finally(() => {
          _loading(this)()
        })
    },
  },
  mounted() {
    const { id } = this.$route.params
    this.eventBus.$emit('clearTap')
    if (id) {
      this.isEdit = false // 标记为修改
      this.editSuervey(id) // 如果传递id就是修改
    } else {
      this.isEdit = true // 标记为创建
    }
  },
  components: { vuedraggable, singleMultiple, topic },
}
</script>

<style lang="scss" scoped>
.edit-main {
  padding: 10px;
  background-color: #f5f5f5;
  margin-left: 50px;
  height: 100vh;
  ::-webkit-scrollbar {
    display: none;
  }

  .header-content {
    padding: 20px;
    width: 70%;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.12), 0 0 6px rgba(0, 0, 0, 0.04);
    min-height: 50px;

    .header-title {
      display: flex;
      justify-content: flex-start;
      align-items: center;
    }
    .header-desc {
      margin-top: 10px;
      display: flex;
      justify-content: flex-start;
      align-items: center;
    }
  }

  .quest-main {
    display: flex;
    margin: 15px 0;
    min-height: 300px;
    width: 70%;
    padding: 1em;
    border: 2px dashed transparent;
    background: linear-gradient(#f5f5f5, #f5f5f5) padding-box,
      repeating-linear-gradient(-45deg, #ccc 0, #ccc 0.25em, white 0, white 0.75em);

    .draggable {
      width: 100%;
      background-color: #f5f5f5;
    }

    .copy-data {
      .data-item {
        padding: 10px 0;
        background-color: #fff;
        display: inline-block;
        width: 100%;
        min-height: 100px;
        margin: 10px 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.12), 0 0 6px rgba(0, 0, 0, 0.04);

        .Gap-content {
          margin: 10px 20px;
          width: 50%;
        }

        .item-single-title {
          margin: 5px 20px;
          display: flex;
          justify-content: space-between;

          .single-title {
            margin: 5px 10px;
          }
        }
        .sub-add {
          margin-left: 10px;
        }
      }
    }
    .text-centre {
      width: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }
  }

  .edit-footer {
    width: 70%;

    .footer-end {
      display: flex;
      justify-content: flex-start;
      align-items: center;
      margin: 20px auto;
    }
  }
}
</style>
