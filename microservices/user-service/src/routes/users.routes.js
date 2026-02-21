import express from 'express'
import {
  register,
  login,
  getProfile,
  updateProfile,
  logout,
  getAllUsers
} from '../controllers/users.controller.js'
import {
  validateRegister,
  validateLogin,
  validateUpdate,
  handleValidationErrors
} from '../middleware/validation.js'

const router = express.Router()

// Public routes
router.post('/register', validateRegister, handleValidationErrors, register)
router.post('/login', validateLogin, handleValidationErrors, login)

// Protected routes (require X-User-Id header from API Gateway)
router.get('/profile', getProfile)
router.put('/profile', validateUpdate, handleValidationErrors, updateProfile)
router.post('/logout', logout)

// Admin routes
router.get('/', getAllUsers)

export default router
