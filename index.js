const getSchedules = require('./lib/get-schedules')

module.exports.handler = async (event) => {
  const body = event.body || {}
  return getSchedules(body.storeId, body.areaId)
}
