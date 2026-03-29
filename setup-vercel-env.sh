#!/bin/bash

# ============================================
# Automated Vercel Environment Setup Script
# ============================================
# This script automatically configures environment variables in Vercel
# using the Vercel API, without manual dashboard interaction

set -e

echo "🚀 Vercel Automated Environment Setup"
echo "════════════════════════════════════════════════════"

# Configuration
VERCEL_TOKEN="${VERCEL_TOKEN}"
VERCEL_PROJECT_ID="${VERCEL_PROJECT_ID:-balaji-construcation}"
API_URL="https://balaji-api-guru.onrender.com"

# Validate prerequisites
if [ -z "$VERCEL_TOKEN" ]; then
    echo "❌ Error: VERCEL_TOKEN environment variable not set"
    echo "   Get your token from: https://vercel.com/account/tokens"
    echo "   Then run: export VERCEL_TOKEN='your-token'"
    exit 1
fi

echo "✓ VERCEL_TOKEN found"
echo "✓ Project: $VERCEL_PROJECT_ID"
echo ""

# Get project details
echo "📍 Fetching project information..."
PROJECT_INFO=$(curl -s -X GET "https://api.vercel.com/v1/projects" \
  -H "Authorization: Bearer $VERCEL_TOKEN" | jq ".projects[] | select(.name==\"$VERCEL_PROJECT_ID\")")

if [ -z "$PROJECT_INFO" ]; then
    echo "❌ Error: Project '$VERCEL_PROJECT_ID' not found in Vercel account"
    exit 1
fi

PROJECT_ID=$(echo "$PROJECT_INFO" | jq -r '.id')
echo "✓ Found project ID: $PROJECT_ID"
echo ""

# Function to set/update environment variable
set_env_var() {
    local ENV_NAME=$1
    local ENV_VALUE=$2
    local ENV_TARGET=$3  # production, preview, or development
    
    echo "📝 Setting: $ENV_NAME = ${ENV_VALUE:0:30}..."
    
    curl -s -X POST "https://api.vercel.com/v2/projects/$PROJECT_ID/env" \
      -H "Authorization: Bearer $VERCEL_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
        \"key\": \"$ENV_NAME\",
        \"value\": \"$ENV_VALUE\",
        \"target\": [\"$ENV_TARGET\"]
      }" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "  ✅ $ENV_NAME set for $ENV_TARGET"
    else
        echo "  ⚠️ May have failed, checking..."
    fi
}

# Set production environment variables
echo "🔧 Setting Production Environment Variables..."
set_env_var "REACT_APP_API_URL" "$API_URL" "production"
set_env_var "REACT_APP_ENV" "production" "production"
set_env_var "REACT_APP_VERSION" "1.0.0" "production"

echo ""
echo "🔧 Setting Preview Environment Variables..."
set_env_var "REACT_APP_API_URL" "http://localhost:5000" "preview"
set_env_var "REACT_APP_ENV" "development" "preview"

echo ""
echo "✅ Vercel environment variables configured!"
echo ""
echo "📋 Next Steps:"
echo "  1. Go to: https://vercel.com/dashboard/projects/$VERCEL_PROJECT_ID"
echo "  2. Click: Deployments"
echo "  3. Redeploy the latest deployment"
echo ""
echo "   OR run: vercel redeploy"
echo ""
