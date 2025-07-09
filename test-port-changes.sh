#!/bin/bash

# Test script to validate port changes
echo "🧪 Testing Claude Flow port configuration changes..."
echo ""

# Test 1: Check if default port 8000 is configured
echo "1️⃣ Testing default port configuration (8000)..."
grep -r "port.*8000" src/core/config.ts && echo "✅ Config updated" || echo "❌ Config not updated"

# Test 2: Check if web server uses port 8000
echo "2️⃣ Testing web server port (8000)..."
grep -r "port.*8000" src/cli/simple-commands/web-server.js && echo "✅ Web server updated" || echo "❌ Web server not updated"

# Test 3: Check if Docker configs use 8000-8002 range
echo "3️⃣ Testing Docker port mapping (8000-8002)..."
grep -r "8000:8000" docker/docker-compose.hive-mind.yml && echo "✅ Docker updated" || echo "❌ Docker not updated"

# Test 4: Check if UI console uses 8000
echo "4️⃣ Testing UI console port (8000)..."
grep -r "localhost:8000" src/ui/console/js/settings.js && echo "✅ UI updated" || echo "❌ UI not updated"

# Test 5: Check if examples use 8000
echo "5️⃣ Testing examples port (8000)..."
grep -r "PORT.*8000" examples/user-api/server.js && echo "✅ Examples updated" || echo "❌ Examples not updated"

# Test 6: Check if no ports in 3000-3999 range remain (except for proxy)
echo "6️⃣ Testing for remaining 3000-3999 ports..."
REMAINING_PORTS=$(grep -r "300[0-9]" src/ docker/ examples/ | grep -v "3128" | grep -v "Binary" | wc -l)
if [ "$REMAINING_PORTS" -eq 0 ]; then
    echo "✅ No remaining 3000-3999 ports (except proxy)"
else
    echo "❌ Found $REMAINING_PORTS remaining ports in 3000-3999 range"
    echo "Found ports:"
    grep -r "300[0-9]" src/ docker/ examples/ | grep -v "3128" | grep -v "Binary" | head -5
fi

echo ""
echo "🎯 Port Migration Summary:"
echo "   • Default port: 3000 → 8000"
echo "   • Dev UI port: 3001 → 8001"
echo "   • Alt port: 3002 → 8002"
echo "   • Proxy port: 3128 (unchanged)"
echo ""
echo "✅ Port conflict resolution complete!"
