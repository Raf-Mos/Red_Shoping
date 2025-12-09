# Red Shopping Frontend

React-based e-commerce frontend application built with Vite, React Router, and TailwindCSS.

## Tech Stack

- **React 18** - UI library
- **Vite** - Build tool
- **React Router** - Client-side routing
- **TailwindCSS** - Utility-first CSS framework
- **Axios** - HTTP client
- **Lucide React** - Icon library

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Environment Variables

Create a `.env` file:

```env
VITE_API_URL=http://localhost:8000
```

## Features

- ✅ Product browsing and search
- ✅ User authentication (login/register)
- ✅ Shopping cart
- ✅ Order management
- ✅ Responsive design
- ✅ JWT token management
- ✅ Protected routes

## Project Structure

```
src/
├── api/            # API client configuration
├── components/     # Reusable UI components
├── context/        # React Context (Auth)
├── pages/          # Page components
├── App.jsx         # Main app component
└── main.jsx        # Entry point
```

## Docker

```bash
# Build image
docker build -t red-shopping-frontend .

# Run container
docker run -p 3000:3000 red-shopping-frontend
```
