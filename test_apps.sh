#!/bin/bash

echo "🔍 Checking for Ktalk applications..."

# List all running applications
echo "📱 All running applications:"
ps aux | grep -i ktalk
ps aux | grep -i толк
ps aux | grep -i m-pm

echo ""
echo "📋 All applications with 'talk' in name:"
ps aux | grep -i talk

echo ""
echo "📋 All applications with 'conference' in name:"
ps aux | grep -i conference

echo ""
echo "📋 All applications with 'meeting' in name:"
ps aux | grep -i meeting
