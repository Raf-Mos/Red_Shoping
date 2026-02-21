import { ShoppingCart } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { useCart } from '../context/CartContext'

const ProductCard = ({ product }) => {
  const navigate = useNavigate()
  const { addToCart } = useCart()

  const handleAddToCart = (e) => {
    e.stopPropagation()
    addToCart(product, 1)
    alert(`${product.name} added to cart!`)
  }

  const handleClick = () => {
    navigate(`/products/${product.id}`)
  }

  return (
    <div 
      className="card p-4 cursor-pointer hover:shadow-lg transition-shadow"
      onClick={handleClick}
    >
      <div className="aspect-square bg-gray-200 rounded-lg mb-4 overflow-hidden">
        <img
          src={product.image || 'https://via.placeholder.com/300'}
          alt={product.name}
          className="w-full h-full object-cover"
        />
      </div>
      
      <h3 className="font-semibold text-lg mb-2">{product.name}</h3>
      <p className="text-gray-600 text-sm mb-4 line-clamp-2">
        {product.description}
      </p>
      
      <div className="flex items-center justify-between">
        <span className="text-2xl font-bold text-primary-600">
          ${product.price.toFixed(2)}
        </span>
        
        <button
          onClick={handleAddToCart}
          className="btn-primary flex items-center space-x-2"
        >
          <ShoppingCart className="w-4 h-4" />
          <span>Add</span>
        </button>
      </div>
      
      {product.stock < 10 && product.stock > 0 && (
        <p className="text-orange-500 text-xs mt-2">
          Only {product.stock} left in stock
        </p>
      )}
      
      {product.stock === 0 && (
        <p className="text-red-500 text-xs mt-2 font-semibold">
          Out of stock
        </p>
      )}
    </div>
  )
}

export default ProductCard
