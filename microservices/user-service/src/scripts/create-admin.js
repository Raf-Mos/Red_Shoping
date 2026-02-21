import mongoose from 'mongoose'
import User from '../models/User.js'

// MongoDB connection string
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://mongodb:27017/users_db'

// Admin user details
const adminUser = {
  name: 'Admin User',
  email: 'admin@redshoping.com',
  password: 'admin123',
  role: 'admin'
}

async function createAdmin() {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGODB_URI)
    console.log('✅ Connected to MongoDB')

    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: adminUser.email })
    
    if (existingAdmin) {
      console.log('⚠️  Admin user already exists')
      console.log('Email:', existingAdmin.email)
      console.log('Role:', existingAdmin.role)
      process.exit(0)
    }

    // Create admin user
    const admin = new User(adminUser)
    await admin.save()

    console.log('✅ Admin user created successfully!')
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
    console.log('📧 Email:', adminUser.email)
    console.log('🔑 Password:', adminUser.password)
    console.log('👤 Role:', adminUser.role)
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
    console.log('⚠️  Please change the password after first login!')

    process.exit(0)
  } catch (error) {
    console.error('❌ Error creating admin:', error)
    process.exit(1)
  }
}

createAdmin()
