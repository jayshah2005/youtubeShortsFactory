#!/bin/bash
PORT=5151

# Stop any existing server
EXISTING_PID=$(lsof -ti tcp:$PORT)
if [ -n "$EXISTING_PID" ]; then
    echo "⚠️  Stopping existing Kokoro server (PID $EXISTING_PID)..."
    kill -9 $EXISTING_PID
fi

# Activate virtual environment
if [ -d "venv" ]; then
    echo "🔹 Activating virtual environment..."
    source venv/bin/activate
fi

# Start server
echo "🚀 Starting Kokoro TTS server on port $PORT..."
python3 server.py
