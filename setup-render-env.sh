#!/bin/bash

# ============================================
# Automated Render Environment Setup Script
# ============================================
# This script automatically configures environment variables in Render
# using the Render API, without manual dashboard interaction

set -e

echo "🚀 Render Automated Environment Setup"
echo "════════════════════════════════════════════════════"

# Configuration
RENDER_API_KEY="${RENDER_API_KEY}"
RENDER_SERVICE_ID="${RENDER_BACKEND_SERVICE_ID}"
FRONTEND_URL="https://balaji-construcation.vercel.app"
MONGODB_URI="${MONGODB_URI:-mongodb+srv://jagruti3945_db_user:K63ZRg7pCUewXurj@balajiconstruction.leuhgrj.mongodb.net/balaji-construction?retryWrites=true&w=majority&appName=BalajiConstruction}"

# Validate prerequisites
if [ -z "$RENDER_API_KEY" ]; then
    echo "❌ Error: RENDER_API_KEY environment variable not set"
    echo "   Get your token from: https://dashboard.render.com/account/api-tokens"
    echo "   Then run: export RENDER_API_KEY='your-key'"
    exit 1
fi

if [ -z "$RENDER_SERVICE_ID" ]; then
    echo "❌ Error: RENDER_BACKEND_SERVICE_ID environment variable not set"
    echo "   Run: export RENDER_BACKEND_SERVICE_ID='srv-xxxxx'"
    exit 1
fi

echo "✓ RENDER_API_KEY found"
echo "✓ Service ID: $RENDER_SERVICE_ID"
echo ""

# Get service details
echo "📍 Fetching service information..."
SERVICE_INFO=$(curl -s -X GET "https://api.render.com/v1/services/$RENDER_SERVICE_ID" \
  -H "Authorization: Bearer $RENDER_API_KEY")

SERVICE_NAME=$(echo "$SERVICE_INFO" | jq -r '.name // empty')

if [ -z "$SERVICE_NAME" ]; then
    echo "❌ Error: Could not fetch service details"
    echo "   Check your RENDER_API_KEY and RENDER_BACKEND_SERVICE_ID"
    exit 1
fi

echo "✓ Found service: $SERVICE_NAME"
echo ""

# Create environment variables JSON
ENV_VARS_JSON=$(cat <<EOF
{
  "envVars": [
    {
      "key": "NODE_ENV",
      "value": "production"
    },
    {
      "key": "PORT",
      "value": "5000"
    },
    {
      "key": "API_URL",
      "value": "https://balaji-api-guru.onrender.com"
    },
    {
      "key": "CORS_ORIGIN",
      "value": "$FRONTEND_URL"
    },
    {
      "key": "MONGODB_URI",
      "value": "$MONGODB_URI"
    },
    {
      "key": "SMTP_SERVICE",
      "value": "gmail"
    },
    {
      "key": "SMTP_USER",
      "value": "more.anil1693@gmail.com"
    },
    {
      "key": "SMTP_FROM",
      "value": "noreply@balajiconstruction.com"
    },
    {
      "key": "BUSINESS_EMAIL",
      "value": "more.anil1693@gmail.com"
    },
    {
      "key": "BUSINESS_PHONE",
      "value": "+91-9637279798"
    },
    {
      "key": "LOG_LEVEL",
      "value": "info"
    }
  ]
}
EOF
)

# Update environment variables
echo "🔧 Updating environment variables..."
RESPONSE=$(curl -s -X PATCH "https://api.render.com/v1/services/$RENDER_SERVICE_ID" \
  -H "Authorization: Bearer $RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$ENV_VARS_JSON")

# Check response
ERROR=$(echo "$RESPONSE" | jq -r '.errorMessage // empty')
if [ -n "$ERROR" ]; then
    echo "❌ Error: $ERROR"
    exit 1
fi

echo "✅ Environment variables updated!"
echo ""

# Display set variables
echo "📋 Variables Set:"
echo "$ENV_VARS_JSON" | jq '.envVars[] | "  ✓ \(.key) = \(.value | .[0:40] + (if (. | length) > 40 then "..." else "" end))"' -r

echo ""
echo "✅ Render environment variables configured!"
echo ""
echo "📋 Next Steps:"
echo "  1. Render will automatically redeploy the service"
echo "  2. Go to: https://dashboard.render.com/services/$RENDER_SERVICE_ID"
echo "  3. Wait for status to show: ✓ Live"
echo ""
