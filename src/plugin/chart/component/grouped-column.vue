<template>
  <div id="grouped-column"></div>
</template>

<script>
// eslint-disable-next-line import/no-extraneous-dependencies
import { GroupColumn } from '@antv/g2plot'

export default {
  name: 'GroupedColumn',
  data() {
    return {
      data: [
        { month: '1月', area: '东区', value: 120 },
        { month: '1月', area: '南区', value: 80 },
        { month: '1月', area: '北区', value: 90 },
        { month: '2月', area: '东区', value: 80 },
        { month: '2月', area: '南区', value: 100 },
        { month: '2月', area: '北区', value: 10 },
        { month: '3月', area: '东区', value: 60 },
        { month: '3月', area: '南区', value: 98 },
        { month: '3月', area: '北区', value: 86 },
        { month: '4月', area: '东区', value: 140 },
        { month: '4月', area: '南区', value: 90 },
        { month: '4月', area: '北区', value: 80 },
        { month: '5月', area: '东区', value: 80 },
        { month: '5月', area: '南区', value: 70 },
        { month: '5月', area: '北区', value: 168 },
        { month: '6月', area: '东区', value: 80 },
        { month: '6月', area: '南区', value: 80 },
        { month: '6月', area: '北区', value: 84 },
        { month: '7月', area: '东区', value: 90 },
        { month: '7月', area: '南区', value: 89 },
        { month: '7月', area: '北区', value: 100 },
      ],
    }
  },
  mounted() {
    const canvas = new GroupColumn('grouped-column', {
      title: {
        text: '各个区域月问卷填写数量',
        visible: true,
      },
      data: this.data,
      groupField: 'area',
      xField: 'month',
      yField: 'value',
      meta: {
        month: {
          alias: '月份',
        },
        value: {
          alias: '数量',
        },
      },
      forceFit: true,
      color: ['#4577FF', '#00C292', '#FEC108'],
      columnSize: 12,
      legend: {
        visible: true,
        position: 'top-right',
      },
    })
    canvas.render()
  },
}
</script>

<style scoped></style>
