<template>
  <div class="sub">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div>第{{ index + 1 }}题： {{ baseData.title }} (包含子选项的题)</div>
      </div>
      <div class="body" v-for="(item, index) in baseData.vice" :key="item.id">
        <template v-if="item.type === 'SingleChoice'">
          <!--单选-->
          <singleChoice :infoData="stepoutData[index]" :baseData="item" :index="index"></singleChoice>
        </template>
        <template v-else-if="item.type === 'MultipleChoice'">
          <!--多选-->
          <multipleChoice :infoData="stepoutData[index]" :baseData="item" :index="index"></multipleChoice>
        </template>
      </div>
    </el-card>
  </div>
</template>

<script>
import singleChoice from '../single-choice/single-choice'
import multipleChoice from '../multiple-choice/multiple-choice'

export default {
  props: {
    infoData: Array,
    baseData: Object,
    index: Number,
  },
  data() {
    return {}
  },
  computed: {
    /** 将数据分割成一道题，一个数组 */
    stepoutData() {
      const setep = {}
      this.infoData.forEach(item => {
        item.vice.forEach((iitem, index) => {
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
  methods: {},
  mounted() {},
  components: {
    singleChoice,
    multipleChoice,
  },
}
</script>

<style lang="scss" scoped>
.sub {
  width: 100%;
  .box-card {
    width: 100%;
    .clearfix {
      position: relative;
      display: flex;
      justify-content: space-between;
      .right {
        position: absolute;
        right: 2rem;
      }
    }
    .table-gead {
      margin: 0 auto;
      width: 100%;
    }
  }
}
</style>
