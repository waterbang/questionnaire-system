<template>
  <div class="gather">
    <div class="header">
      <div class="title"><icon name="stock" /><span class="detail">数据概况</span></div>
      <div class="content">
        <div class="new-add">
          <div>今日新增数据</div>
          <div></div>
        </div>
        <div class="gross">
          <div>答题总量</div>
          <div>{{ gross }}</div>
        </div>
        <div class="mean-time">
          <div>平均答题时常</div>
          <div></div>
        </div>
      </div>
    </div>
    <div class="main"></div>
  </div>
</template>

<script>
import surveyModel from '@/model/survey'

import icon from '@/component/base/icon/lin-icon'

export default {
  data() {
    return {
      infoData: [],
    }
  },
  computed: {
    gross: () => this.infoData.length, // 答题总量
    newAdd: () => {
      // const time = this.infoData
    },
  },
  mounted() {
    this.initInfo()
  },
  methods: {
    async initInfo() {
      const { id } = this.$route.params
      this.infoData = await surveyModel.gatherInfo(id)
      console.log(this.infoData)
    },
  },
  components: {
    icon,
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
      width: 97%;
      margin: 0.5rem 0;
      text-align: left;
      .detail {
        position: relative;
        bottom: 0.2rem;
      }
    }
    .content {
      background: #fff;
      width: 97%;
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
}
</style>
