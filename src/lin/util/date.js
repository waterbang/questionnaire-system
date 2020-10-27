import moment from 'moment'

// 设置语言为中文
moment.locale('zh-cn')

/**
 * @param {number} hours
 */
export function getDateAfterHours(hours) {
  const now = new Date()
  return new Date(now.setHours(now.getHours() + hours))
}
/**
 * @param {number} days
 */
export function getDateAfterDays(days) {
  const now = new Date()
  return new Date(now.setHours(now.getHours() + days * 24))
}

export function getStartEndSecond(time) {
  return Math.floor((time % (24 * 3600 * 1000 * 3600 * 1000 * 60 * 1000 * 1000)) / 1000)
}
