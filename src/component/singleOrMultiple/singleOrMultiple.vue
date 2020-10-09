<template>
  <div>
    <div class="item-single-title">
      <div @click="showEdit(false)" class="single-title" v-if="editData">
        {{ element.title }} （{{ element.type === 'SingleChoice' ? '单选题' : '多选题' }}）
      </div>
      <el-input
        style="width:50%; float: left;"
        type="text"
        v-if="!editData"
        v-model="element.title"
        placeholder="请输入您的问卷标题"
        @change="showEdit(true)"
      />
      <div class="single-delete">
        <i v-if="element.type === 'MultipleChoice'" class="el-icon-set-up" @click="drawer = true"></i>
        <i v-if="sonIndex === undefined" class="el-icon-rank handle"></i>
        <i class="el-icon-delete" @click="deleteItem(elIndex)"></i>
      </div>
    </div>
    <div class="single" v-for="(item, index) in element.choice_list" :key="index">
      <div class="single-input-item">
        <div v-if="item != '其他'">
          <el-input class="single-input" type="text" v-model="element.choice_list[index]">{{ item }}</el-input>
          <i @click="deleteOption(elIndex, index)" class="el-icon-circle-close"></i>
        </div>
        <div v-else>
          <!-- 其他 -->
          <el-input class="single-input" type="text" v-model="element.choice_list[index]" disabled>{{ item }}</el-input>
          <i @click="deleteOption(elIndex, index)" class="el-icon-circle-close"></i>
        </div>
      </div>
    </div>
    <div class="single-add">
      <el-button type="primary" icon="el-icon-plus" plain @click="addOption(elIndex)">增加普通选项</el-button>
      <el-button type="primary" icon="el-icon-plus" plain @click="addElse(elIndex)">增加其他选项</el-button>
    </div>
    <w-drawer
      :drawer="drawer"
      :element="element"
      @setDrawer="setDrawer"
      @setMinDrawer="setMinDrawer"
      @setMaxDrawer="setMaxDrawer"
    ></w-drawer>
  </div>
</template>
<script>
import WDrawer from './w_drawer'

export default {
  inheritAttrs: false,
  props: {
    element: Object,
    elIndex: Number,
    sonIndex: Number,
  },
  data() {
    return {
      editData: true, // 是否点击到
      drawer: false,
    }
  },
  methods: {
    // 切换header
    showEdit(flag) {
      this.editData = flag
    },
    // 添加选项
    addOption(index) {
      this.$emit('addOption', index, this.sonIndex)
    },
    // 删除选项
    deleteOption(index, opIndex) {
      this.$emit('deleteOption', index, opIndex, this.sonIndex)
    },
    // 删除题目
    deleteItem(index) {
      this.$emit('deleteItem', index, this.sonIndex)
    },
    // 增加其他选项
    addElse(index) {
      this.$emit('addElse', index, this.sonIndex)
    },
    // 控制右侧弹窗
    setDrawer(flag) {
      this.drawer = flag
    },
    // 设置最小值
    setMinDrawer(val) {
      this.element.minChoice = val || 0
    },
    // 设置最大值
    setMaxDrawer(val) {
      this.element.maxChoice = val || 100
    },
  },
  components: { WDrawer },
}
</script>
<style lang="scss" scoped>
.fa {
  display: inline-block;
  font: normal normal normal 14px / 1 FontAwesome;
  font-size: inherit;
  text-rendering: auto;
  -webkit-font-smoothing: antialiased;
}

.item-single-title {
  margin: 5px 20px;
  display: flex;
  justify-content: space-between;

  .single-title {
    margin: 5px 10px;
  }
}

.single {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  margin: 10px auto;
  width: 100%;

  .single-input-item {
    display: flex;
    justify-content: flex-start;
    align-items: baseline;
    width: 100%;

    > div {
      width: 100%;
      display: flex;
      justify-content: flex-start;
      align-items: baseline;
    }

    .single-input {
      width: 50%;
      margin: 0 10px;
    }
  }
}

.single-add {
  margin: 10px auto;
}
</style>
