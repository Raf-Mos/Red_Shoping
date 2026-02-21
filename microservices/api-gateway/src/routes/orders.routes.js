import express from 'express'
import axios from 'axios'
import { authMiddleware } from '../middleware/auth.js'
import { apiLimiter } from '../middleware/rateLimiter.js'

const router = express.Router()

const ORDER_SERVICE_URL = process.env.ORDER_SERVICE_URL || 'http://localhost:8003'

// All order routes require authentication

// Get user's orders
router.get('/', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.get(`${ORDER_SERVICE_URL}/api/orders`, {
      headers: {
        'X-User-Id': req.user.userId
      }
    })
    
    res.json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Get order by ID
router.get('/:id', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.get(`${ORDER_SERVICE_URL}/api/orders/${req.params.id}`, {
      headers: {
        'X-User-Id': req.user.userId
      }
    })
    
    res.json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Create order
router.post('/', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.post(
      `${ORDER_SERVICE_URL}/api/orders`, 
      req.body,
      {
        headers: {
          'X-User-Id': req.user.userId,
          'X-User-Email': req.user.email
        }
      }
    )
    
    res.status(201).json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Cancel order
router.patch('/:id/cancel', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.patch(
      `${ORDER_SERVICE_URL}/api/orders/${req.params.id}/cancel`,
      {},
      {
        headers: {
          'X-User-Id': req.user.userId
        }
      }
    )
    
    res.json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

export default router
