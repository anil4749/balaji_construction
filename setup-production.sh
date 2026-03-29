#!/bin/bash

# ============================================
# Master Production Environment Setup Script
# ============================================
# This script automatically configures environment variables
# for both Vercel and Render using their APIs

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   🚀 Balaji Construction - Production Environment Setup    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Validate and collect credentials
echo "${BLUE}Step 1: Validating Credentials${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Check Vercel Token
if [ -z "$VERCEL_TOKEN" ]; then
    echo "${RED}❌ VERCEL_TOKEN not set${NC}"
    echo ""
    echo "   Get your Vercel token:"
    echo "   1. Visit: https://vercel.com/account/tokens"
    echo "   2. Create new token"
    echo "   3. Copy the token"
    echo ""
    read -p "   Paste your VERCEL_TOKEN: " VERCEL_TOKEN
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "${RED}❌ VERCEL_TOKEN is required${NC}"
    exit 1
fi
echo "${GREEN}✓ VERCEL_TOKEN received${NC}"

# Check Render API Key
if [ -z "$RENDER_API_KEY" ]; then
    echo "${RED}❌ RENDER_API_KEY not set${NC}"
    echo ""
    echo "   Get your Render API key:"
    echo "   1. Visit: https://dashboard.render.com/account/api-tokens"
    echo "   2. Create new token"
    echo "   3. Copy the token"
    echo ""
    read -p "   Paste your RENDER_API_KEY: " RENDER_API_KEY
fi

if [ -z "$RENDER_API_KEY" ]; then
    echo "${RED}❌ RENDER_API_KEY is required${NC}"
    exit 1
fi
echo "${GREEN}✓ RENDER_API_KEY received${NC}"

# Check Render Service ID
if [ -z "$RENDER_BACKEND_SERVICE_ID" ]; then
    echo "${RED}❌ RENDER_BACKEND_SERVICE_ID not set${NC}"
    echo ""
    echo "   Get your service ID:"
    echo "   1. Visit: https://dashboard.render.com"
    echo "   2. Select 'balaji-api-guru' service"
    echo "   3. Copy the Service ID from URL or settings"
    echo "   (Format: srv-xxxxxxxxxxxxx)"
    echo ""
    read -p "   Paste your RENDER_BACKEND_SERVICE_ID: " RENDER_BACKEND_SERVICE_ID
fi

if [ -z "$RENDER_BACKEND_SERVICE_ID" ]; then
    echo "${RED}❌ RENDER_BACKEND_SERVICE_ID is required${NC}"
    exit 1
fi
echo "${GREEN}✓ RENDER_BACKEND_SERVICE_ID received${NC}"

echo ""
echo "${GREEN}✅ All credentials received${NC}"
echo ""

# Step 2: Configure Vercel
echo "${BLUE}Step 2: Configuring Vercel${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""

VERCEL_PROJECT_ID="balaji-construcation"
API_URL="https://balaji-api-guru.onrender.com"

echo "📍 Fetching Vercel project information..."

# Get project details
PROJECT_INFO=$(curl -s -X GET "https://api.vercel.com/v1/projects" \
  -H "Authorization: Bearer $VERCEL_TOKEN" | jq ".projects[] | select(.name==\"$VERCEL_PROJECT_ID\")" 2>/dev/null)

if [ -z "$PROJECT_INFO" ]; then
    echo "${RED}❌ Error: Project '$VERCEL_PROJECT_ID' not found${NC}"
    echo "   Make sure you have deployed to Vercel first"
    exit 1
fi

PROJECT_ID=$(echo "$PROJECT_INFO" | jq -r '.id')
echo "${GREEN}✓ Found project: $VERCEL_PROJECT_ID ($PROJECT_ID)${NC}"
echo ""

# Set Vercel environment variables
echo "📝 Setting environment variables..."

ENV_VARS=(
    "REACT_APP_API_URL:$API_URL:production"
    "REACT_APP_ENV:production:production"
    "REACT_APP_API_URL:http://localhost:5000:preview"
    "REACT_APP_ENV:development:preview"
)

for ENV_VAR in "${ENV_VARS[@]}"; do
    IFS=':' read -r KEY VALUE TARGET <<< "$ENV_VAR"
    
    echo -n "  Setting $KEY for $TARGET... "
    
    RESPONSE=$(curl -s -X POST "https://api.vercel.com/v2/projects/$PROJECT_ID/env" \
      -H "Authorization: Bearer $VERCEL_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"key\": \"$KEY\", \"value\": \"$VALUE\", \"target\": [\"$TARGET\"]}")
    
    if echo "$RESPONSE" | jq -e '.id // .key' > /dev/null 2>&1; then
        echo "${GREEN}✓${NC}"
    else
        echo "${YELLOW}⚠${NC}"
    fi
done

echo ""
echo "${GREEN}✅ Vercel configured${NC}"
echo ""

# Step 3: Configure Render
echo "${BLUE}Step 3: Configuring Render${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""

FRONTEND_URL="https://balaji-construcation.vercel.app"
MONGODB_URI="${MONGODB_URI:-mongodb+srv://jagruti3945_db_user:K63ZRg7pCUewXurj@balajiconstruction.leuhgrj.mongodb.net/balaji-construction?retryWrites=true&w=majority&appName=BalajiConstruction}"

echo "📍 Fetching Render service information..."

SERVICE_INFO=$(curl -s -X GET "https://api.render.com/v1/services/$RENDER_BACKEND_SERVICE_ID" \
  -H "Authorization: Bearer $RENDER_API_KEY" 2>/dev/null)

SERVICE_NAME=$(echo "$SERVICE_INFO" | jq -r '.name // empty')

if [ -z "$SERVICE_NAME" ]; then
    echo "${RED}❌ Error: Could not fetch service details${NC}"
    echo "   Check your RENDER_API_KEY and RENDER_BACKEND_SERVICE_ID"
    exit 1
fi

echo "${GREEN}✓ Found service: $SERVICE_NAME${NC}"
echo ""
echo "📝 Setting environment variables..."

# Create environment variables JSON
ENV_VARS_JSON=$(cat <<EOF
{
  "envVars": [
    {"key": "NODE_ENV", "value": "production"},
    {"key": "PORT", "value": "5000"},
    {"key": "API_URL", "value": "https://balaji-api-guru.onrender.com"},
    {"key": "CORS_ORIGIN", "value": "$FRONTEND_URL"},
    {"key": "MONGODB_URI", "value": "$MONGODB_URI"},
    {"key": "SMTP_SERVICE", "value": "gmail"},
    {"key": "SMTP_USER", "value": "more.anil1693@gmail.com"},
    {"key": "SMTP_FROM", "value": "noreply@balajiconstruction.com"},
    {"key": "BUSINESS_EMAIL", "value": "more.anil1693@gmail.com"},
    {"key": "BUSINESS_PHONE", "value": "+91-9637279798"},
    {"key": "LOG_LEVEL", "value": "info"}
  ]
}
EOF
)

# Update environment variables
RESPONSE=$(curl -s -X PATCH "https://api.render.com/v1/services/$RENDER_BACKEND_SERVICE_ID" \
  -H "Authorization: Bearer $RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$ENV_VARS_JSON")

ERROR=$(echo "$RESPONSE" | jq -r '.errorMessage // empty' 2>/dev/null)
if [ -n "$ERROR" ] && [ "$ERROR" != "null" ]; then
    echo "${RED}❌ Error: $ERROR${NC}"
    exit 1
fi

echo "${GREEN}✓ Environment variables updated${NC}"
echo ""
echo "${GREEN}✅ Render configured${NC}"
echo ""

# Step 4: Summary and Next Steps
echo "${BLUE}Step 4: Verification & Next Steps${NC}"
echo "═══════════════════════════════════════════════════════════"
echo ""

echo "${GREEN}✅ Configuration Complete!${NC}"
echo ""
echo "📋 Summary:"
echo "  • Vercel: $VERCEL_PROJECT_ID"
echo "    - REACT_APP_API_URL = $API_URL (Production)"
echo "    - REACT_APP_ENV = production (Production)"
echo ""
echo "  • Render: $SERVICE_NAME"
echo "    - NODE_ENV = production"
echo "    - CORS_ORIGIN = $FRONTEND_URL"
echo "    - API_URL = https://balaji-api-guru.onrender.com"
echo ""

echo "🔄 Next Steps:"
echo ""
echo "1. Redeploy Vercel Frontend:"
echo "   ${YELLOW}vercel redeploy${NC}"
echo "   OR visit: https://vercel.com/dashboard/projects/$VERCEL_PROJECT_ID"
echo ""
echo "2. Wait for Render Auto-Deploy:"
echo "   Visit: https://dashboard.render.com/services/$RENDER_BACKEND_SERVICE_ID"
echo "   Wait for status: ✓ Live"
echo ""
echo "3. Hard Refresh Browser:"
echo "   ${YELLOW}Cmd+Shift+R${NC} (Mac) or ${YELLOW}Ctrl+Shift+R${NC} (Windows)"
echo "   Then visit: ${BLUE}https://balaji-construcation.vercel.app${NC}"
echo ""
echo "4. Verify Everything Works:"
echo "   • Check DevTools Console for API calls"
echo "   • Projects should load"
echo "   • Forms should submit"
echo ""
echo "${GREEN}✨ You're all set! 🚀${NC}"
echo ""
