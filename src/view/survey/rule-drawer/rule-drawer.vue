<template>
  <div>
    <el-drawer title="问卷规则设置" :visible.sync="drawer" :direction="direction" :before-close="handleClose">
      <div class="item">
        <div class="optional-scope-title">是否可复制</div>
        <div class="optional-scope-content">
          <el-switch v-model="rule.is_copy" active-color="#13ce66"> </el-switch>
        </div>
      </div>
      <div class="item">
        <div class="optional-scope-title">是否需要登录</div>
        <div class="optional-scope-content">
          <el-switch v-model="rule.is_login" active-color="#13ce66"> </el-switch>
        </div>
      </div>
      <div class="item">
        <div class="optional-scope-title">一台设备可以填几次</div>
        <div class="optional-scope-content">
          <el-input-number v-model="rule.limit_ip" :min="1" :max="10"></el-input-number>
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
    }
  },
  methods: {
    handleClose() {
      this.$emit('setDrawer', this.rule)
    },
  },
  props: {
    drawer: Boolean,
    rule: Object,
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
  margin-bottom: 15px;
}

.optional-scope-content {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}
</style>
