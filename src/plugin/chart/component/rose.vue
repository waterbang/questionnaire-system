<template>
  <div id="rose"></div>
</template>

<script>
// eslint-disable-next-line import/no-extraneous-dependencies
import { Rose } from '@antv/g2plot'

export default {
  name: 'Rose',
  data() {
    return {
      data: [
        {
          type: '公司统计',
          value: 270,
        },
        {
          type: '员工统计',
          value: 250,
        },
        {
          type: '战略统计',
          value: 188,
        },
        {
          type: '技术产品统计',
          value: 236,
        },
        {
          type: '技术部统计',
          value: 170,
        },
        {
          type: '销售部统计',
          value: 150,
        },
      ],
    }
  },
  mounted() {
    new Rose('rose', {
      title: {
        text: '问卷分析',
        visible: true,
      },
      data: this.data,
      radiusField: 'value',
      categoryField: 'type',
      colorField: 'type',
    }).render()
  },
}
</script>

<style scoped></style>
