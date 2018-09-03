require('dotenv').config()
const { Pool } = require('pg')
const {
  AppError,
  InternalServerError,
  BadRequestError
} = require('./errors')

const client = new Pool({
  user: process.env.DB_USERNAME,
  host: process.env.DB_HOST,
  password: process.env.DB_PASSWORD,
  database: 'postgres',
  port: 5432
})

module.exports = async function getSchedules (storeId, areaId, time) {
  time = time || (new Date()).toISOString()
  if (!storeId) throw new BadRequestError('[storeId] is required')
  if (!areaId) throw new BadRequestError('[areaId] is required')

  try {
    console.log('time', time)
    const result = await client
      .query('SELECT * FROM get_schedules($1, $2)', [storeId, time])
    return result.rows
  } catch (error) {
    console.log('error', error)
    if (error instanceof AppError) {
      throw error
    } else {
      throw new InternalServerError(error.message)
    }
  }
}
