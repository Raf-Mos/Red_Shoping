import express from 'express'
import axios from 'axios'
import { authMiddleware, optionalAuth } from '../middleware/auth.js'
import { apiLimiter, searchLimiter } from '../middleware/rateLimiter.js'

const router = express.Router()

const PRODUCT_SERVICE_URL = process.env.PRODUCT_SERVICE_URL || 'http://localhost:8001'

// Get all products (with optional search)
router.get('/', apiLimiter, searchLimiter, async (req, res, next) => {
  try {
    const { search, category, minPrice, maxPrice } = req.query
    
    const params = new URLSearchParams()
    if (search) params.append('search', search)
    if (category) params.append('category', category)
    if (minPrice) params.append('minPrice', minPrice)
    if (maxPrice) params.append('maxPrice', maxPrice)

    const response = await axios.get(`${PRODUCT_SERVICE_URL}/api/products?${params}`)
    
    res.json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Get product by ID
router.get('/:id', apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.get(`${PRODUCT_SERVICE_URL}/api/products/${req.params.id}`)
    res.json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Create product (admin only - requires auth)
router.post('/', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.post(`${PRODUCT_SERVICE_URL}/api/products`, req.body, {
      headers: {
        'X-User-Id': req.user.userId
      }
    })
    
    res.status(201).json(response.data)
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json(error.response.data)
    }
    next(error)
  }
})

// Update product (admin only - requires auth)
router.put('/:id', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.put(
      `${PRODUCT_SERVICE_URL}/api/products/${req.params.id}`, 
      req.body,
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

// Delete product (admin only - requires auth)
router.delete('/:id', authMiddleware, apiLimiter, async (req, res, next) => {
  try {
    const response = await axios.delete(`${PRODUCT_SERVICE_URL}/api/products/${req.params.id}`, {
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

export default router
