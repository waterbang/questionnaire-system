<template>
  <div class="mult">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div>第{{ index + 1 }}题： {{ baseData.title }} (多选题)</div>
        <div class="right">回答人数：{{ infoData.length }} 人</div>
      </div>
      <div :id="'multiple-choice-' + random"></div>
      <el-table :data="columnData" style="width:90%" class="table-gead">
        <el-table-column type="index" label="答题序号" width="400"> </el-table-column>
        <el-table-column prop="type" label="回答详情" min-width> </el-table-column>
        <el-table-column prop="sales" label="回答人数" min-width> </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { Column } from '@antv/g2plot'

export default {
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
    columnData() {
      const data = {}
      const res = []
      this.infoData.map(item => {
        delete item.type
        if (item.choice_list instanceof Array) {
          item.choice_list.map(iitem => {
            if (data[iitem]) {
              data[iitem]++
            } else {
              data[iitem] = 1
            }
            return iitem
          })
          return
        }
        if (data[item.choice_list]) {
          data[item.choice_list]++
        } else {
          data[item.choice_list] = 1
        }
        return item
      })
      for (const [type, sales] of Object.entries(data)) {
        res.push({ type, sales })
      }
      return res
    },
  },
  methods: {
    mountedColumn(data) {
      new Column(`multiple-choice-${this.random}`, {
        data,
        xField: 'type',
        yField: 'sales',
        label: {
          // 可手动配置 label 数据标签位置
          position: 'middle', // 'top', 'bottom', 'middle',
          // 配置样式
          style: {
            fill: '#0D0E68',
            opacity: 0.6,
          },
        },
        meta: {
          type: {
            alias: '类别',
          },
          sales: {
            alias: '人数',
          },
        },
      }).render()
    },
  },
  mounted() {
    this.mountedColumn(this.columnData)
  },
}
</script>

<style lang="scss" scoped>
.mult {
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
