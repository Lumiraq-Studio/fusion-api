import {DataSource, DataSourceOptions} from 'typeorm'
import * as dotenv from 'dotenv'
import * as process from "node:process";

dotenv.config()


export const dataSourceOptions: DataSourceOptions = {
  type: 'mysql',
  host: process.env.DB_HOST,
  port: +process.env.DB_PORT,
  username: process.env.DB_USER,
  password: process.env.DB_PWD,
  database: process.env.DATABASE,
  entities: ['dist/**/*.schema.js'],
  migrations: ['dist/src/database/migrations/*.js'],
  extra: {
    connectionLimit:20,
    queueLimit:100,
    waitForConnections: true,
    idleTimeoutMillis: 30000
  }
}


const dataSource = new DataSource(dataSourceOptions)
export default dataSource

