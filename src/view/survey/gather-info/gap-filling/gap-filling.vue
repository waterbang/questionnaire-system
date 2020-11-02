<template>
  <div class="gap">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <div>第{{ index + 1 }}题： {{ baseData.title }} (填空题)</div>
        <div class="right">回答人数：{{ infoData.length }} 人</div>
      </div>
      <el-table :data="infoData" style="width:90%" class="table-gead">
        <el-table-column type="index" label="答题序号" width="400"> </el-table-column>
        <el-table-column prop="fillGap" label="回答详情" min-width> </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
export default {
  props: {
    infoData: Array,
    baseData: Object,
    index: Number,
  },
  methods: {},
}
</script>

<style lang="scss" scoped>
.gap {
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
