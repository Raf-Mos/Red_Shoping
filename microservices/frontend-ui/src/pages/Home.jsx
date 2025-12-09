import { Link } from 'react-router-dom'
import { ShoppingBag, TrendingUp, Shield, Truck } from 'lucide-react'

const Home = () => {
  return (
    <div>
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-primary-500 to-primary-700 text-white rounded-2xl p-12 mb-12">
        <div className="max-w-3xl">
          <h1 className="text-5xl font-bold mb-4">
            Welcome to Red Shopping
          </h1>
          <p className="text-xl mb-8 text-primary-100">
            Discover amazing products at unbeatable prices. Your one-stop shop for everything you need.
          </p>
          <Link to="/products" className="inline-block bg-white text-primary-600 font-semibold px-8 py-3 rounded-lg hover:bg-primary-50 transition">
            Shop Now
          </Link>
        </div>
      </section>

      {/* Features */}
      <section className="grid md:grid-cols-4 gap-6 mb-12">
        <div className="card p-6 text-center">
          <ShoppingBag className="w-12 h-12 text-primary-600 mx-auto mb-4" />
          <h3 className="font-semibold mb-2">Wide Selection</h3>
          <p className="text-gray-600 text-sm">Thousands of products to choose from</p>
        </div>
        
        <div className="card p-6 text-center">
          <TrendingUp className="w-12 h-12 text-primary-600 mx-auto mb-4" />
          <h3 className="font-semibold mb-2">Best Prices</h3>
          <p className="text-gray-600 text-sm">Competitive prices guaranteed</p>
        </div>
        
        <div className="card p-6 text-center">
          <Truck className="w-12 h-12 text-primary-600 mx-auto mb-4" />
          <h3 className="font-semibold mb-2">Fast Delivery</h3>
          <p className="text-gray-600 text-sm">Quick and reliable shipping</p>
        </div>
        
        <div className="card p-6 text-center">
          <Shield className="w-12 h-12 text-primary-600 mx-auto mb-4" />
          <h3 className="font-semibold mb-2">Secure Payment</h3>
          <p className="text-gray-600 text-sm">Your transactions are safe</p>
        </div>
      </section>

      {/* CTA Section */}
      <section className="card p-8 text-center">
        <h2 className="text-3xl font-bold mb-4">Ready to Start Shopping?</h2>
        <p className="text-gray-600 mb-6">
          Create an account to enjoy exclusive benefits and track your orders
        </p>
        <div className="flex justify-center space-x-4">
          <Link to="/register" className="btn-primary">
            Create Account
          </Link>
          <Link to="/products" className="btn-secondary">
            Browse Products
          </Link>
        </div>
      </section>
    </div>
  )
}

export default Home
