<template>
  <div id="line"></div>
</template>

<script>
// eslint-disable-next-line import/no-extraneous-dependencies
import { Line } from '@antv/g2plot'

export default {
  name: 'Line',
  data() {
    return {
      data: [
        { month: '1月', value: 10, type: '东区' },
        { month: '2月', value: 8, type: '东区' },
        { month: '3月', value: 10, type: '东区' },
        { month: '4月', value: 7, type: '东区' },
        { month: '5月', value: 12, type: '东区' },
        { month: '6月', value: 8, type: '东区' },
        { month: '7月', value: 6, type: '东区' },
        { month: '1月', value: 5, type: '南区' },
        { month: '2月', value: 16, type: '南区' },
        { month: '3月', value: 18, type: '南区' },
        { month: '4月', value: 16, type: '南区' },
        { month: '5月', value: 16, type: '南区' },
        { month: '6月', value: 9, type: '南区' },
        { month: '7月', value: 10, type: '南区' },
        { month: '1月', value: 9, type: '北区' },
        { month: '2月', value: 16, type: '北区' },
        { month: '3月', value: 10, type: '北区' },
        { month: '4月', value: 13, type: '北区' },
        { month: '5月', value: 8, type: '北区' },
        { month: '6月', value: 9, type: '北区' },
        { month: '7月', value: 12, type: '北区' },
      ],
    }
  },
  mounted() {
    new Line('line', {
      title: {
        visible: true,
        text: '各区域填写趋势分析',
      },
      data: this.data,
      forceFit: true,
      seriesField: 'type',
      xField: 'month',
      yField: 'value',
      smooth: true,
      color: ['#4577FF', '#00C292', '#FEC108'],
      legend: {
        visible: true,
        position: 'top-right',
      },
    }).render()
  },
}
</script>

<style scoped></style>
