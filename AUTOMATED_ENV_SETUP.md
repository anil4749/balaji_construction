# 🤖 Automated Production Environment Setup

> **No manual dashboards needed!** Set up Vercel and Render environment variables automatically via API.

## ⚡ Quick Start (1 Command)

```bash
chmod +x setup-production.sh
./setup-production.sh
```

That's it! The script will:
1. ✅ Prompt you for your API credentials
2. ✅ Validate them with Vercel & Render
3. ✅ Automatically configure all environment variables
4. ✅ Show you verification steps

---

## 🔑 What You Need

Before running the script, have these ready:

### Vercel API Token
1. Visit: https://vercel.com/account/tokens
2. Click: "Create Token"
3. Give it a name (e.g., "BalajiSetup")
4. Copy the token

### Render API Key
1. Visit: https://dashboard.render.com/account/api-tokens
2. Click: "Create API Token"
3. Copy the token

### Render Backend Service ID
1. Visit: https://dashboard.render.com
2. Select your "balaji-api-guru" service
3. Copy the Service ID (format: `srv-xxxxxxxxxxxxx`)

---

## 📝 Usage Methods

### Method 1: Interactive (Recommended)
```bash
./setup-production.sh
```
Script will prompt you for credentials interactively.

### Method 2: Environment Variables
```bash
export VERCEL_TOKEN="your-vercel-token"
export RENDER_API_KEY="your-render-api-key"
export RENDER_BACKEND_SERVICE_ID="srv-xxxxxxxxxxxxx"
./setup-production.sh
```

### Method 3: One Command
```bash
VERCEL_TOKEN="..." RENDER_API_KEY="..." RENDER_BACKEND_SERVICE_ID="..." ./setup-production.sh
```

---

## 🛠️ Individual Scripts

If you want to set up only one platform:

### Vercel Only
```bash
chmod +x setup-vercel-env.sh
export VERCEL_TOKEN="your-token"
./setup-vercel-env.sh
```

### Render Only
```bash
chmod +x setup-render-env.sh
export RENDER_API_KEY="your-api-key"
export RENDER_BACKEND_SERVICE_ID="srv-xxxxx"
./setup-render-env.sh
```

---

## 📋 What Gets Configured

### Vercel (Frontend)
| Variable | Value | Environment |
|----------|-------|-------------|
| `REACT_APP_API_URL` | `https://balaji-api-guru.onrender.com` | Production |
| `REACT_APP_ENV` | `production` | Production |
| `REACT_APP_API_URL` | `http://localhost:5000` | Preview |
| `REACT_APP_ENV` | `development` | Preview |

### Render (Backend)
| Variable | Value |
|----------|-------|
| `NODE_ENV` | `production` |
| `PORT` | `5000` |
| `API_URL` | `https://balaji-api-guru.onrender.com` |
| `CORS_ORIGIN` | `https://balaji-construcation.vercel.app` |
| `MONGODB_URI` | MongoDB connection string |
| `SMTP_SERVICE` | `gmail` |
| `SMTP_FROM` | `noreply@balajiconstruction.com` |
| `BUSINESS_EMAIL` | `more.anil1693@gmail.com` |
| `BUSINESS_PHONE` | `+91-9637279798` |
| `LOG_LEVEL` | `info` |

---

## ✅ After Running the Script

1. **Vercel Redeploy:**
   ```bash
   vercel redeploy
   ```
   OR visit Vercel dashboard and click "Redeploy" on latest deployment

2. **Render Auto-Deploy:**
   - Render automatically redeploys when environment variables change
   - Go to dashboard and wait for status: ✓ Live

3. **Verify:**
   - Hard refresh: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+R` (Windows)
   - Visit: https://balaji-construcation.vercel.app
   - Open DevTools → Console
   - Check for no CORS errors

---

## 🔍 Troubleshooting

### "VERCEL_TOKEN not set"
```bash
export VERCEL_TOKEN="your-token-from-vercel.com"
./setup-production.sh
```

### "RENDER_API_KEY not set"
```bash
export RENDER_API_KEY="your-key-from-render-dashboard"
./setup-production.sh
```

### "Project not found"
- Vercel: Make sure you've deployed to Vercel first
- Check project name is "balaji-construcation"

### "Could not fetch service details"
- Render: Verify your API key and Service ID are correct
- Make sure Service ID starts with `srv-`

### "Curl command not found"
- Mac: `brew install curl`
- Linux: `apt-get install curl`
- Windows: Use WSL or Git Bash

### "jq command not found"
- Mac: `brew install jq`
- Linux: `apt-get install jq`
- Windows: Download from https://stedolan.github.io/jq/

---

## 🔒 Security Notes

- ✅ Tokens are NOT stored in any file
- ✅ Tokens are only used for API calls during this session
- ✅ Never commit tokens to git
- ✅ If you leak a token, regenerate it immediately on the platform

---

## 📊 What Happens

```
1. Script validates credentials with Vercel API
   ↓
2. Script gets your Vercel project ID
   ↓
3. Script creates environment variables in Vercel
   ↓
4. Vercel queues a new deployment
   ↓
5. Script validates credentials with Render API
   ↓
6. Script gets your Render service info
   ↓
7. Script updates environment variables in Render
   ↓
8. Render automatically redeploys with new variables
   ↓
✅ Done!
```

---

## 🚀 Full Example

```bash
# Step 1: Get your tokens ready (have them copied from dashboards)

# Step 2: Run the script
chmod +x setup-production.sh
./setup-production.sh

# Step 3: When prompted, paste your tokens
# Paste your VERCEL_TOKEN: vcp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# Paste your RENDER_API_KEY: your-render-api-key
# Paste your RENDER_BACKEND_SERVICE_ID: srv-xxxxxxxxxxxxx

# Step 4: Script does everything automatically
✅ Configuration Complete!

# Step 5: Redeploy Vercel
vercel redeploy

# Step 6: Wait for Render (auto-deploys)
# Check: https://dashboard.render.com

# Step 7: Hard refresh and test
# https://balaji-construcation.vercel.app
```

---

## 📞 Need Help?

If something goes wrong:

1. **Check error message** - scripts provide detailed error messages
2. **Verify credentials** - wrong token will show specific error
3. **Check dashboards** - verify tokens are still valid
4. **Re-run script** - scripts are idempotent (safe to run multiple times)

---

## ✨ Benefits of Automated Setup

| Manual | Automated |
|--------|-----------|
| ❌ 15+ dashboard clicks | ✅ 1 command |
| ❌ Easy to miss steps | ✅ Never misses anything |
| ❌ Risk of typos | ✅ Perfect accuracy |
| ❌ Time consuming | ✅ 30 seconds |
| ❌ Error prone | ✅ Validates everything |
| ✅ (nothing) | ✅ Repeatable |

---

**You're ready!** 🚀

Next time you need to update production environment variables, just run:
```bash
./setup-production.sh
```

Done!
