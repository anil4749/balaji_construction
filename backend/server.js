const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const mongoose = require('mongoose');

// Load environment variables
dotenv.config();

const app = express();

// Configuration from environment variables
const PORT = process.env.PORT || 5000;
const NODE_ENV = process.env.NODE_ENV || 'development';
const MONGODB_URI = process.env.MONGODB_URI;
const BASE_CORS_ORIGIN = process.env.CORS_ORIGIN || 'http://localhost:3000';
const API_URL = process.env.API_URL || `http://localhost:${PORT}`;

// CORS origin matcher - accepts main domain and all Vercel preview URLs
const corsOriginMatcher = (origin, callback) => {
  const allowedOrigins = [
    BASE_CORS_ORIGIN,
    'http://localhost:3000',
    'http://localhost:3001',
    /^https:\/\/balaji-construction.*\.vercel\.app$/,  // Matches all Vercel preview URLs (corrected spelling)
  ];

  // Allow requests with no origin (like mobile apps or curl requests)
  if (!origin || origin === 'undefined') {
    return callback(null, true);
  }

  const isAllowed = allowedOrigins.some(allowed => {
    if (typeof allowed === 'string') {
      return allowed === origin;
    }
    if (allowed instanceof RegExp) {
      return allowed.test(origin);
    }
    return false;
  });

  if (isAllowed) {
    callback(null, true);
  } else {
    console.warn(`❌ CORS blocked origin: ${origin}`);
    callback(new Error('CORS not allowed'));
  }
};

// Log configuration (without sensitive data)
console.log('='.repeat(50));
console.log('🚀 Server Configuration:');
console.log(`   Environment: ${NODE_ENV}`);
console.log(`   Port: ${PORT}`);
console.log(`   CORS Origin: ${BASE_CORS_ORIGIN}`);
console.log(`   API URL: ${API_URL}`);
console.log(`   MongoDB: ${MONGODB_URI ? '✓ Connected' : '❌ Not configured'}`);
console.log('='.repeat(50));

// CORS configuration
const corsOptions = {
  origin: corsOriginMatcher,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  exposedHeaders: ['Content-Length', 'X-JSON-Response-Length'],
  maxAge: 86400
};

app.use(cors(corsOptions));
app.options('*', cors(corsOptions)); // Handle preflight requests
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// MongoDB Connection (optional - will use sample data if not available)
if (MONGODB_URI) {
  const mongooseOptions = {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    ssl: true,
    tlsInsecure: false,
    retryWrites: true,
    serverSelectionTimeoutMS: 5000,
    connectTimeoutMS: 5000,
    bufferCommands: false,
    socketTimeoutMS: 45000
  };

  mongoose.connect(MONGODB_URI, mongooseOptions)
    .then(() => console.log('✓ MongoDB connected successfully'))
    .catch(err => {
      console.error('❌ MongoDB connection error:', err.message);
      console.log('ℹ️ Server will use sample data for development');
    });
} else {
  console.log('ℹ️ MONGODB_URI not set - using sample data mode');
}

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Server is running', 
    environment: NODE_ENV,
    timestamp: new Date(),
    uptime: process.uptime()
  });
});

// Routes
app.use('/api/inquiries', require('./routes/inquiries'));
app.use('/api/projects', require('./routes/projects'));
app.use('/api/contact', require('./routes/contact'));
app.use('/api/images', require('./routes/images'));

// Root-level images route (for direct /images/drive/... access)
app.use('/images', require('./routes/images'));

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found', path: req.path });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('❌ Error:', err.stack);
  res.status(err.status || 500).json({ 
    error: NODE_ENV === 'production' ? 'Server error' : err.message,
    details: NODE_ENV === 'development' ? err.stack : undefined
  });
});

// Start server
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`✓ Server running on port ${PORT}`);
  console.log(`✓ API available at ${API_URL}/api`);
  console.log(`✓ Health check: ${API_URL}/api/health`);
  console.log(`✓ Press Ctrl+C to stop`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('⚠️ SIGTERM received - shutting down gracefully');
  server.close(() => {
    console.log('✓ Server closed');
    mongoose.connection.close(false, () => {
      console.log('✓ MongoDB connection closed');
      process.exit(0);
    });
  });
});

process.on('SIGINT', () => {
  console.log('⚠️ SIGINT received - shutting down gracefully');
  server.close(() => {
    console.log('✓ Server closed');
    mongoose.connection.close(false, () => {
      console.log('✓ MongoDB connection closed');
      process.exit(0);
    });
  });
});
