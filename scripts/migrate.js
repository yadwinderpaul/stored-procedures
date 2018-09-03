require('dotenv').config()
const fs = require('fs')
const { resolve } = require('path')
const { Client } = require('pg')

const command = process.argv[2]
const commands = ['up', 'down']
if (!command || commands.indexOf(command) < 0) {
  console.error("Please specify a valid command: 'up' or 'down'")
} else {
  const client = new Client({
    user: process.env.DB_USERNAME,
    host: process.env.DB_HOST,
    password: process.env.DB_PASSWORD,
    database: 'postgres',
    port: 5432
  })

  ;(async function () {
    try {
      const migrations = []
      const migrationsPath = resolve(__dirname, 'migrations')
      fs.readdirSync(migrationsPath).forEach(pathname => {
        const fullpath = resolve(migrationsPath, pathname)
        if (fs.lstatSync(fullpath).isDirectory()) {
          const sqlPath = resolve(fullpath, `${command}.sql`)
          const sql = fs.readFileSync(sqlPath, 'utf-8')
          migrations.push({
            name: pathname,
            path: fullpath,
            sql: sql
          })
        }
      })

      await client.connect()

      for (let migration of migrations) {
        console.log(`Executing: ${migration.name}`)
        await client.query(migration.sql)
      }

      console.log('Done')
    } catch (error) {
      console.log(`Error in executing migration: ${error.message}`)
    } finally {
      await client.end()
    }
  })()
}
