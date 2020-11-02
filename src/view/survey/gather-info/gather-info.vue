<template>
  <div class="gather">
    <div class="header">
      <div class="title"><icon name="stock" /><span class="detail">数据概况</span></div>
      <div class="content">
        <div class="new-add">
          <div>今日新增数据</div>
          <div>{{ todayAdd }}</div>
        </div>
        <div class="gross">
          <div>答题总量</div>
          <div>{{ gross }}</div>
        </div>
        <div class="mean-time">
          <div>平均答题时常</div>
          <div>{{ quiz_time }}</div>
        </div>
      </div>
    </div>
    <div class="main">
      <div class="title"><icon name="pointmap" /><span class="detail">统计报表</span></div>
      <div class="top" :class="navBarFixed == true ? 'navBarWrap' : ''">
        <el-button>题目筛选</el-button>
      </div>
      <div class="body" v-for="(item, index) in baseData.detail" :key="item.id">
        <template v-if="item.type === 'SingleChoice'">
          <!--单选-->
          <singleChoice :infoData="stepoutData[index]" :baseData="item" :index="index"></singleChoice>
        </template>
        <template v-else-if="item.type === 'MultipleChoice'">
          <!--多选-->
          <multipleChoice :infoData="stepoutData[index]" :baseData="item" :index="index"></multipleChoice>
        </template>
        <template v-else-if="item.type === 'GapFilling'">
          <!--填空-->
          <gapFilling :infoData="stepoutData[index]" :baseData="item" :index="index"></gapFilling>
        </template>
        <template v-else-if="item.type === 'SubQuestions'">
          <!--包含子选项的题目-->
          <subQuestions :infoData="stepoutData[index]" :baseData="item" :index="index"></subQuestions>
        </template>
        <template v-else>
          <!--没有这种题型-->
          <div class="msg">很抱歉！，暂时不支持这种题型，请通过订阅号进行反馈</div>
          <img src="@/assets/image/about/qrcode.jpg" alt="前端方舟" />
        </template>
      </div>
      <div class="noll" v-if="infoData.length === 0">
        <div>此问卷还没有人填写哦~</div>
        <img class="img" src="@/assets/image/detail/null.gif" alt="没有收集问卷" />
      </div>
    </div>
  </div>
</template>

<script>
import surveyModel from '@/model/survey'
import { formatSeconds } from '@/lin/util/date'
import icon from '@/component/base/icon/lin-icon'
import gapFilling from './gap-filling/gap-filling'
import multipleChoice from './multiple-choice/multiple-choice'
import singleChoice from './single-choice/single-choice'
import subQuestions from './sub-questions/sub-questions'

export default {
  data() {
    return {
      infoData: [], // 用户填的数据
      baseData: [], // 问卷基础数据
      navBarFixed: false,
    }
  },
  computed: {
    // 今日新增
    gross() {
      return this.infoData.length
    }, // 答题总数
    todayAdd() {
      return this.infoData.filter(item => new Date().getTime() - new Date(item.create_time).getTime() < 86400000).length
    },
    quiz_time() {
      let aver = 0
      if (this.infoData.length === 0) return 0
      this.infoData.forEach(item => {
        aver += item.quiz_time
      })
      const quiz = Math.floor(aver / this.infoData.length)
      return formatSeconds(quiz)
    },
    /** 将数据分割成一道题，一个数组 */
    stepoutData() {
      const setep = {}
      this.infoData.forEach(item => {
        item.detail.forEach((iitem, index) => {
          if (setep[index]) {
            setep[index].push(iitem)
          } else {
            setep[index] = [iitem]
          }
        })
      })
      return setep
    },
  },
  mounted() {
    this.initInfo() // 初始化数据
    window.addEventListener('scroll', this.watchScroll) // 监听吸顶事件
  },
  methods: {
    /** 初始化渲染数据 */
    async initInfo() {
      const { id } = this.$route.params
      this.infoData = await surveyModel.gatherInfo(id)
      this.baseData = await surveyModel.getSurvey(id)
      // console.log(this.infoData)
    },
    /** 页面下拉固定 */
    watchScroll() {
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop
      //  当滚动超过 50 时，实现吸顶效果
      if (scrollTop > 49) {
        this.navBarFixed = true
      } else {
        this.navBarFixed = false
      }
    },
  },
  components: {
    icon,
    gapFilling,
    multipleChoice,
    singleChoice,
    subQuestions,
  },
}
</script>

<style lang="scss" scoped>
.gather {
  .header {
    height: 10rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    .title {
      width: 90%;
      margin: 0.5rem 0;
      text-align: left;
      .detail {
        position: relative;
        bottom: 0.2rem;
      }
    }
    .content {
      background: #fff;
      width: 90%;
      height: 15rem !important;
      box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.1);
      display: flex;
      justify-content: space-around;
      align-items: center;
      .new-add,
      .gross,
      .mean-time {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: space-around;
        height: 4rem;
      }
    }
  }
  .main {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    .title {
      width: 97%;
      margin: 0.5rem 0;
      text-align: left;
      .detail {
        position: relative;
        bottom: 0.2rem;
      }
    }
    .navBarWrap {
      position: fixed;
      top: 0;
      z-index: 999;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    }
    .top {
      width: 95%;
      display: flex;
      justify-content: space-between;
      margin: 0 2rem;
      padding: 1rem;
      background-color: #fff;
      border-bottom: 1px solid #f3f3f3;
    }
    .body {
      width: 95%;
      margin-bottom: 1rem;
    }
    .noll {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      .img {
        margin: 2rem;
        width: 34rem;
        height: 27rem;
      }
    }
  }
}
</style>
