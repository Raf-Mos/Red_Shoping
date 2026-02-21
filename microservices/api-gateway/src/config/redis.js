import { createClient } from 'redis'
import logger from '../utils/logger.js'

const redisClient = createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379
  },
  password: process.env.REDIS_PASSWORD || undefined
})

redisClient.on('error', (err) => {
  logger.error('Redis Client Error:', err)
})

redisClient.on('connect', () => {
  logger.info('✅ Redis connected successfully')
})

// Connect to Redis
await redisClient.connect()

export default redisClient
