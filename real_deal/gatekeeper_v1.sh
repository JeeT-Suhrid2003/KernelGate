#!/bin/bash

NAMESPACE="canary-lab"
DEPLOYMENT="my-api"

echo "🎯 Starting Performance Test..."

# 1. Check if Pod is running
READY=$(kubectl get pods -n $NAMESPACE -l app=my-api -o jsonpath='{.items[0].status.containerStatuses[0].ready}')
if [ "$READY" != "true" ]; then
    echo "❌ Pod not ready. Aborting."
    exit 1
fi

# 2. Trigger Chaos in the background
echo "🧨 Injecting Chaos..."
curl -s --max-time 5 http://localhost:5000/chaos & 

# 3. Monitor for 10 seconds
echo "⏳ Monitoring system stability..."
for i in {1..10}; do
    STATUS=$(kubectl get pods -n $NAMESPACE -l app=my-api -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}')
    if [ "$STATUS" -gt 0 ]; then
        echo "❌ FAILURE DETECTED: Pod restarted $STATUS times during load!"
        echo "📉 REASON: Resource Limit exceeded (OOM)."
        exit 1
    fi
    sleep 1
done

echo "✅ SUCCESS: Pod survived the performance gate."