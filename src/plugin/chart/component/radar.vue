<template>
  <div id="Radar"></div>
</template>

<script>
// eslint-disable-next-line import/no-extraneous-dependencies
import { Radar } from '@antv/g2plot'

export default {
  name: 'Radar',
  data() {
    return {
      data: [
        { type: '今天晚上吃什么', mark: '技术部', value: 80 },
        { type: '公司的团建', mark: '技术部', value: 20 },
        { type: '对黄柚子抽奖小程序的测试看法', mark: '技术部', value: 60 },
        { type: '销售产品心得统计', mark: '技术部', value: 40 },
        { type: '网络安全防范问卷', mark: '技术部', value: 70 },
        { type: '今天晚上吃什么', mark: '销售部', value: 70 },
        { type: '公司的团建', mark: '销售部', value: 50 },
        { type: '对黄柚子抽奖小程序的测试看法', mark: '销售部', value: 90 },
        { type: '销售产品心得统计', mark: '销售部', value: 80 },
        { type: '网络安全防范问卷', mark: '销售部', value: 20 },
      ],
    }
  },
  mounted() {
    new Radar('Radar', {
      title: {
        text: '技术部和销售部问卷填写数量',
        visible: true,
      },
      data: this.data,
      radiusField: 'value',
      angleField: 'type',
      seriesField: 'mark',
      color: ['#4577FF', '#FEC108'],
      legend: {
        visible: true,
        position: 'top-right',
      },
    }).render()
  },
}
</script>

<style scoped></style>
