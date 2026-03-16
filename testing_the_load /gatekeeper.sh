#!/bin/bash
# monitor.sh - The Automated Performance Gate

THRESHOLD=100 # Max 100MB allowed
APP_NAME="challenge1_k8s-app-monitor-1"

echo "Starting Performance Gate for $APP_NAME..."

while true; do
  # Get memory usage in MB using docker stats
  MEM_USAGE=$(docker stats --no-stream --format "{{.MemUsage}}" $APP_NAME | awk '{print $1}' | sed 's/MiB//')
  
  # Convert to integer for comparison
  MEM_INT=${MEM_USAGE%.*}

  if [ "$MEM_INT" -gt "$THRESHOLD" ]; then
    echo "🚨 CRITICAL: Memory Leak Detected! ($MEM_USAGE)"
    echo "ACTION: Rolling back deployment..."
    docker restart $APP_NAME
    echo "System recovered. Analyzing logs..."
    break
  fi

  echo "Status: Healthy ($MEM_USAGE)"
  sleep 2
done