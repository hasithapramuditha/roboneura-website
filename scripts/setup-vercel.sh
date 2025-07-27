#!/bin/bash

# RoboNeura Vercel CI/CD Setup Script
# This script helps set up Vercel deployment with GitHub Actions

echo "🚀 Setting up Vercel CI/CD for RoboNeura..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Check if user is logged in to Vercel
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please log in to Vercel..."
    vercel login
fi

# Link project to Vercel
echo "🔗 Linking project to Vercel..."
vercel link

# Get project configuration
echo "📋 Getting project configuration..."
if [ -f ".vercel/project.json" ]; then
    echo "✅ Project linked successfully!"
    echo ""
    echo "📝 Please add the following secrets to your GitHub repository:"
    echo ""
    
    # Extract project ID and org ID
    PROJECT_ID=$(grep -o '"projectId":"[^"]*"' .vercel/project.json | cut -d'"' -f4)
    ORG_ID=$(grep -o '"orgId":"[^"]*"' .vercel/project.json | cut -d'"' -f4)
    
    echo "VERCEL_PROJECT_ID: $PROJECT_ID"
    echo "VERCEL_ORG_ID: $ORG_ID"
    echo ""
    echo "🔑 To get VERCEL_TOKEN:"
    echo "1. Go to https://vercel.com/account/tokens"
    echo "2. Create a new token"
    echo "3. Add it as VERCEL_TOKEN in GitHub Secrets"
    echo ""
    echo "📍 GitHub Secrets location:"
    echo "Repository Settings → Secrets and variables → Actions"
    echo ""
    echo "🎉 Setup complete! Your next push to main will trigger deployment."
else
    echo "❌ Failed to link project. Please run 'vercel link' manually."
    exit 1
fi 