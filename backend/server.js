// 🌍 Yenkasa Community Backend Server
// ----------------------------------

// ✅ Load environment variables
require('dotenv').config();

const express = require('express');
const path = require('path');
const mongoose = require('mongoose');
const fs = require('fs');
const helmet = require('helmet');
const compression = require('compression');
const cors = require('cors');
const morgan = require('morgan');
const http = require('http');
const { Server } = require('socket.io');

// 🧩 Models
const User = require('./models/user.model');
const CoinSupply = require('./models/coinSupply');
const CoinTransaction = require('./models/coinTransaction');

// ⚙️ Services
const verificationEvaluator = require('./services/verificationEvaluator');
const verificationRules = require('./config/verificationRules');

// 🚀 App initialization
const app = express();
console.log("🌍 Starting YenkasaCommunity backend setup...");

// ---------------------------------
// MongoDB Connection
// ---------------------------------
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(async () => {
  console.log('✅ MongoDB connected (YenkasaCommunity database)');
})
.catch(err => console.error('❌ MongoDB connection error:', err));

// ---------------------------------
// HTTP + Socket.IO Setup
// ---------------------------------
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: process.env.CLIENT_URL || "*",
    methods: ["GET", "POST"],
  },
});

// ---------------------------------
// Global Middlewares
// ---------------------------------
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.CLIENT_URL || "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
  credentials: true,
}));
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV !== "test") app.use(morgan("dev"));
console.log("✅ Core middlewares configured.");

// ---------------------------------
// 🟢 SOCKET.IO USER PRESENCE SYSTEM
// ---------------------------------
const onlineUsers = new Map();

io.on('connection', (socket) => {
  console.log(`💡 Socket connected: ${socket.id}`);

  // ✅ User comes online
  socket.on('userConnected', async ({ userId }) => {
    if (!userId) return;
    onlineUsers.set(userId, socket.id);
    await User.findByIdAndUpdate(userId, { online: true }, { new: true });
    io.emit('getOnlineUsers', Array.from(onlineUsers.keys()));
    console.log(`🟢 User ${userId} connected`);
  });

  // ✅ User disconnects
  socket.on('disconnect', async () => {
    for (let [userId, socketId] of onlineUsers.entries()) {
      if (socketId === socket.id) {
        onlineUsers.delete(userId);
        await User.findByIdAndUpdate(userId, { online: false, lastSeen: new Date() });
        console.log(`🔴 User ${userId} disconnected`);
        break;
      }
    }
    io.emit('getOnlineUsers', Array.from(onlineUsers.keys()));
  });
});

// ---------------------------------
// API Routes Mounting
// ---------------------------------
function safeMount(routePath, filePath) {
  try {
    app.use(routePath, require(filePath));
    console.log(`✅ Mounted ${filePath} at ${routePath}`);
  } catch (err) {
    console.error(`❌ Failed to mount ${filePath} at ${routePath}: ${err.message}`);
  }
}

// 🧭 Main API routes
console.log("⚙️ Mounting API routes...");
safeMount('/api/auth', './routes/auth');
safeMount('/api/users', './routes/user.routes');
safeMount('/api/contacts', './routes/contacts.routes');
safeMount('/api/messages', './routes/messages.routes');
safeMount('/api/chatrooms', './routes/chatroom.routes');
safeMount('/api/social', './routes/social.routes');
safeMount('/api/posts', './routes/posts');
safeMount('/api/coins', './routes/coins');
safeMount('/api/notifications', './routes/notifications.route');
safeMount('/api/profile', './routes/profile');
safeMount('/api/account', './routes/account.routes');
safeMount('/api/verify', './routes/verify');

console.log("✅ All routes mounted successfully!");

// ---------------------------------
// Health Check
// ---------------------------------
app.get("/health", (req, res) => {
  res.status(200).json({
    app: "YenkasaCommunity Backend",
    status: "ok",
    uptime: process.uptime(),
    env: process.env.NODE_ENV || "development"
  });
});

// ---------------------------------
// Static Assets (Public, Terms, etc.)
// ---------------------------------
app.use(express.static(path.join(__dirname, 'public')));
app.get('/terms', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'user_agreement.html'));
});

// ---------------------------------
// Error Handling
// ---------------------------------
app.use((req, res, next) => {
  if (req.originalUrl.startsWith("/api/")) {
    return res.status(404).json({ error: "API route not found" });
  }
  next();
});

app.use((err, req, res, next) => {
  console.error("🔥 Internal Server Error:", err);
  res.status(500).json({ error: "Something went wrong on the server." });
});

// ---------------------------------
// Start Server
// ---------------------------------
const PORT = process.env.PORT || 5000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 YenkasaCommunity backend running on port ${PORT}`);
  console.log(`🔌 Socket.IO active and listening`);
});
