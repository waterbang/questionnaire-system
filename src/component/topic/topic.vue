<template>
  <div class="topic">
    <div class="choice">
      <div class="choice-title">候选题型</div>
      <el-row :gutter="24">
        <el-col :span="24">
          <vuedraggable
            class="base-dragg"
            :list="base"
            :group="{ name: '_data', pull: 'clone', put: false }"
            :clone="checkMove"
          >
            <div class="base-data" v-for="element in base" :key="element.name">
              <el-tooltip effect="dark" content="需要我把我向右拉🍭" placement="right">
                <div v-if="element.type === 'SingleChoice'">单选题</div>
              </el-tooltip>
              <el-tooltip effect="dark" content="需要我把我向右拉🍭" placement="right">
                <div v-if="element.type === 'MultipleChoice'">多选题</div>
              </el-tooltip>
              <el-tooltip effect="dark" content="有一个主标题，加4个只选项🍭" placement="right">
                <div v-if="element.type === 'SubQuestions'">包含子项的选择题</div>
              </el-tooltip>
              <el-tooltip effect="dark" content="需要我把我向右拉🍭" placement="right">
                <div v-if="element.type === 'GapFilling'">填空题</div>
              </el-tooltip>
            </div>
          </vuedraggable>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
import vuedraggable from 'vuedraggable'

export default {
  data() {
    return {
      base: [
        {
          choice_list: ['选项一', '选项二'],
          title: '请从下面选择一个选项',
          type: 'SingleChoice',
        },
        {
          choice_list: ['选项一', '选项二'],
          title: '请从下面选择多个选项',
          type: 'MultipleChoice',
        },
        {
          vice: [
            {
              choice_list: ['选项一', '选项一'],
              title: '请从下面选择一个选项',
              type: 'SingleChoice',
            },
            {
              choice_list: ['选项一', '选项二', '选项三'],
              title: '请从下面选择多个选项',
              type: 'MultipleChoice',
            },
          ],
          main_title: '我是一个包含子选项的题目',
          type: 'SubQuestions',
        },
        {
          fillGap: '',
          title: '我是填空题',
          type: 'GapFilling',
        },
      ],
    }
  },
  methods: {
    checkMove(event) {
      this.$emit('cloneData', event)
    },
  },
  components: { vuedraggable },
}
</script>
<style lang="scss" scoped>
.topic {
  .choice {
    margin: 10px 0;

    .choice-title {
      margin-bottom: 10px;
    }

    .base-dragg {
      margin: 10px;
      padding: 10px;

      .base-data {
        > div {
          padding: 10px 15px;
          border: 1px solid #555;
          margin: 10px;
          box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        }
      }
    }
  }
}
</style>
