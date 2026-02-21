import express from 'express'
import axios from 'axios'
import jwt from 'jsonwebtoken'
import { body, validationResult } from 'express-validator'
import { authLimiter } from '../middleware/rateLimiter.js'
import { AppError } from '../middleware/errorHandler.js'

const router = express.Router()

const USER_SERVICE_URL = process.env.USER_SERVICE_URL || 'http://localhost:8002'
const JWT_SECRET = process.env.JWT_SECRET || 'your-super-secret-jwt-key'
const JWT_EXPIRATION = process.env.JWT_EXPIRATION || '24h'

// Validation rules
const registerValidation = [
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('name').trim().notEmpty().withMessage('Name is required')
]

const loginValidation = [
  body('email').isEmail().normalizeEmail(),
  body('password').notEmpty().withMessage('Password is required')
]

// Register
router.post('/register', authLimiter, registerValidation, async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false, 
        errors: errors.array() 
      })
    }

    const { name, email, password } = req.body

    // Forward to User Service
    const response = await axios.post(`${USER_SERVICE_URL}/api/users/register`, {
      name,
      email,
      password
    })

    const user = response.data

    // Generate JWT
    const token = jwt.sign(
      { 
        userId: user.id, 
        email: user.email,
        name: user.name,
        role: user.role || 'user'
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRATION }
    )

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role || 'user'
      }
    })
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json({
        success: false,
        message: error.response.data.message || 'Registration failed'
      })
    }
    next(error)
  }
})

// Login
router.post('/login', authLimiter, loginValidation, async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        success: false, 
        errors: errors.array() 
      })
    }

    const { email, password } = req.body

    // Forward to User Service
    const response = await axios.post(`${USER_SERVICE_URL}/api/users/login`, {
      email,
      password
    })

    const user = response.data

    // Generate JWT
    const token = jwt.sign(
      { 
        userId: user.id, 
        email: user.email,
        name: user.name,
        role: user.role || 'user'
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRATION }
    )

    res.json({
      success: true,
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role || 'user'
      }
    })
  } catch (error) {
    if (error.response) {
      return res.status(error.response.status).json({
        success: false,
        message: error.response.data.message || 'Login failed'
      })
    }
    next(error)
  }
})

// Verify token (for testing)
router.get('/verify', async (req, res) => {
  try {
    const authHeader = req.headers.authorization
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        message: 'No token provided' 
      })
    }

    const token = authHeader.substring(7)
    const decoded = jwt.verify(token, JWT_SECRET)

    res.json({
      success: true,
      user: decoded
    })
  } catch (error) {
    res.status(401).json({ 
      success: false, 
      message: 'Invalid token' 
    })
  }
})

export default router
