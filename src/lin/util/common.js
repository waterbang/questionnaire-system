export const _loading = (that, text = 'loading') => {
  const loading = that.$loading({
    lock: true,
    text,
    spinner: 'el-icon-loading',
    background: 'rgba(0, 0, 0, 0.7)',
  })
  return () => {
    loading.close()
  }
}

export const DeepClone = target => {
  if (typeof target === 'object') {
    const cloneTarget = Array.isArray(target) ? [] : {}
    for (const key in target) {
      cloneTarget[key] = DeepClone(target[key])
    }
    return cloneTarget
  }
  return target
}
