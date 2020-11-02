<template>
  <div class="container">
    <el-row :gutter="20">
      <el-col :span="16">
        <div class="grid-content bg-purple">
          <group-column></group-column>
        </div>
      </el-col>
      <el-col :span="8" class="none">
        <div class="grid-content bg-purple">
          <radar></radar>
        </div>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="16">
        <el-row :gutter="20">
          <el-col :span="12">
            <div class="grid-content bg-purple">
              <tiny-area-july></tiny-area-july>
            </div>
          </el-col>
          <el-col :span="12">
            <div class="grid-content bg-purple">
              <tiny-area-june></tiny-area-june>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <div class="grid-content bg-purple">
              <line-charts></line-charts>
            </div>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="8" class="none">
        <div class="grid-content bg-purple">
          <rose></rose>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import GroupColumn from '../component/grouped-column'
import Radar from '../component/radar'
import TinyAreaJuly from '../component/tiny-area-july'
import TinyAreaJune from '../component/tiny-area-june'
import LineCharts from '../component/line-chart'
import Rose from '../component/rose'

export default {
  components: {
    Rose,
    GroupColumn,
    Radar,
    TinyAreaJuly,
    TinyAreaJune,
    LineCharts,
  },
  data() {
    return {}
  },
}
</script>

<style lang="scss" scoped>
.container {
  padding: 20px;
  .el-row {
    .el-col {
      .grid-content {
        background: #ffffff;
        box-shadow: 0px 2px 14px 0px rgba(243, 243, 243, 1);
        border-radius: 8px;
        min-height: 36px;
        margin-bottom: 20px;
      }
    }
  }
}
@media screen and (max-width: 1200px) {
  .none {
    display: none;
  }
}
</style>
