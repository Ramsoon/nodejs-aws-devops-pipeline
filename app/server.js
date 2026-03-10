const express = require("express");
const redis = require("redis");

const app = express();
app.use(express.json());

// Load env variables
const PORT = process.env.PORT || 3000;
const REDIS_HOST = process.env.REDIS_HOST || "redis";
const REDIS_PORT = process.env.REDIS_PORT || 6379;

// Create Redis client
const client = redis.createClient({
  url: `redis://${REDIS_HOST}:${REDIS_PORT}`
});

// Connect to Redis
client.connect()
  .then(() => console.log("Connected to Redis"))
  .catch((err) => console.error("Redis connection error:", err));

/*
Used by load balancers and monitoring tools
*/
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    service: "node-app"
  });
});

/*
some status
Returns application and Redis status
*/
app.get("/status", async (req, res) => {

  const redisStatus = client.isOpen ? "connected" : "disconnected";

  res.status(200).json({
    app: "running",
    redis: redisStatus,
    environment: process.env.NODE_ENV || "development"
  });

});

/*
process endpoint
Stores data in Redis and returns confirmation
*/
app.post("/process", async (req, res) => {

  try {

    const { data } = req.body;

    if (!data) {
      return res.status(400).json({
        error: "data field is required"
      });
    }

    // Save data to Redis
    await client.set("last_processed_data", data);

    res.status(200).json({
      message: "Data processed successfully",
      stored_value: data
    });

  } catch (error) {

    res.status(500).json({
      error: "Processing failed",
      details: error.message
    });

  }

});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});