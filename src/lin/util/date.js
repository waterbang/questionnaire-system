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

// 将秒数转换为时分秒格式
export function formatSeconds(value) {
  let theTime = Math.floor(value) // 秒
  let middle = 0 // 分
  let hour = 0 // 小时

  if (theTime > 60) {
    middle = Math.floor(theTime / 60)
    theTime = Math.floor(theTime % 60)
    if (middle > 60) {
      hour = Math.floor(middle / 60)
      middle = Math.floor(middle % 60)
    }
  }
  let result = `${Math.floor(theTime)}秒`
  if (middle > 0) {
    result = `${Math.floor(middle)}分${result}`
  }
  if (hour > 0) {
    result = `${Math.floor(hour)}小时${result}`
  }
  return result
}
