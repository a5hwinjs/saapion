#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to cleanly stop background processes
cleanup() {
    echo ""
    echo "Stopping Saapion services..."
    # Kill all processes started in the background by this script
    kill $(jobs -p) 2>/dev/null || true
    echo "Services stopped successfully."
    exit
}

# Trap SIGINT (Ctrl+C) and SIGTERM
trap cleanup SIGINT SIGTERM

echo "========================================="
echo "        Starting Saapion App             "
echo "========================================="

# 1. Start the FastAPI Backend
echo "Starting Backend (FastAPI)..."
cd backend
if [ -d "venv" ]; then
    source venv/bin/activate
else
    echo "Warning: Virtual environment 'venv' not found in backend/."
fi
uvicorn main:app --reload --port 8000 &
cd ..

# 2. Start the Nuxt 3 Frontend
echo "Starting Frontend (Nuxt 3)..."
cd frontend
npm run dev &
cd ..

echo "========================================="
echo "Saapion is booting up!"
echo "Backend API: http://localhost:8000"
echo "Frontend UI: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all services."
echo "========================================="

# Wait for all background processes to keep the script running
wait
