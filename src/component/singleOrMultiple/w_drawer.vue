<template>
  <div>
    <el-drawer title="选项逻辑设置" :visible.sync="drawer" :direction="direction" :before-close="handleClose">
      <div class="item">
        <div class="optional-scope-title">可选范围</div>
        <div class="optional-scope-content">
          <div>
            <el-select v-model="minValue" placeholder="最少选择">
              <el-option
                v-for="(item, index) in element.choice_list"
                :key="index"
                :label="`最少选择${index + 1}项`"
                :value="index"
              ></el-option>
            </el-select>
          </div>
          <div>
            <el-select v-model="maxValue" placeholder="最多选择">
              <el-option
                v-for="(item, index) in maxLen"
                :key="index"
                :label="`最多选择${index + 1 + minValue}项`"
                :value="index + minValue"
              ></el-option>
            </el-select>
          </div>
        </div>
      </div>
    </el-drawer>
  </div>
</template>
<script>
export default {
  data() {
    return {
      direction: 'rtl',
      minValue: '任意',
      maxValue: '任意',
      maxLen: [], // 可选的最大值长度
      minVal: null, // 最少选择
      maxVal: null, // 最多选择
    }
  },
  methods: {
    handleClose() {
      this.$emit('setDrawer', false)
    },
  },
  watch: {
    minValue(val) {
      const len = this.element.choice_list.length - val
      this.maxLen.length = len
      this.$emit('setMinDrawer', val + 1)
    },
    maxValue(val) {
      this.$emit('setMaxDrawer', val + 1)
    },
  },
  props: {
    element: Object,
    drawer: Boolean,
  },
}
</script>

<style lang="scss" scoped>
.item {
  padding: 10px;
  margin: 10px;
  border: 1px solid #d7dae2;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: baseline;
}

.optional-scope-title {
  font-weight: 600;
  margin-bottom: 5px;
}

.optional-scope-content {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}
</style>
