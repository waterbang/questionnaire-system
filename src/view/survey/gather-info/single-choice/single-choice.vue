<template>
  <div class="single">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div>第{{ index + 1 }}题： {{ baseData.title }} (单选题)</div>
        <div class="right">回答人数：{{ infoData.length }} 人</div>
      </div>
      <div :id="'plot-pie-' + random"></div>
      <el-table :data="pieData" style="width:90%" class="table-gead">
        <el-table-column type="index" label="答题序号" width="400"> </el-table-column>
        <el-table-column prop="type" label="回答详情" min-width> </el-table-column>
        <el-table-column prop="value" label="回答人数" min-width> </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { Pie } from '@antv/g2plot'

export default {
  name: 'singleChoice',
  props: {
    infoData: Array,
    baseData: Object,
    index: Number,
  },
  data() {
    return {
      random: Math.random(), // 防止id重复
    }
  },
  computed: {
    pieData() {
      const data = {}
      const res = []
      this.infoData.map(item => {
        delete item.type
        if (data[item.choice_list]) {
          data[item.choice_list]++
        } else {
          data[item.choice_list] = 1
        }
        return item
      })
      for (const [type, value] of Object.entries(data)) {
        res.push({ type, value })
      }
      return res
    },
  },
  methods: {
    mountedPie(data) {
      new Pie(`plot-pie-${this.random}`, {
        appendPadding: 10,
        data,
        angleField: 'value',
        colorField: 'type',
        radius: 0.8,
        tooltip: {
          showTitle: false,
        },
        label: {
          type: 'spider',
          content: '{name}\n{percentage}',
        },
        interactions: [{ type: 'element-active' }],
      }).render()
    },
  },
  mounted() {
    console.log('sub', this.baseData)
    console.log('sub', this.infoData)
    console.log('subbb', this.pieData)
    this.mountedPie(this.pieData)
  },
}
</script>

<style lang="scss" scoped>
.single {
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
