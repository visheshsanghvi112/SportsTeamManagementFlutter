# Image Loading Debug Guide

## Common Issues on Vercel

### Issue 1: Assets Not Loading (404 errors)
**Cause**: Routing configuration catching asset requests
**Fix**: Updated `vercel.json` to use `"handle": "filesystem"` first

### Issue 2: CORS Errors
**Cause**: Missing CORS headers for assets
**Fix**: Added `Access-Control-Allow-Origin: *` to assets

### Issue 3: Wrong Asset Paths
**Cause**: Flutter web needs correct base href
**Fix**: Base href is set to "/" in index.html

## How to Debug on Live Site

1. **Open Browser DevTools** (F12)
2. **Go to Network tab**
3. **Reload the page**
4. **Look for failed requests** (red ones)

### What to Check:

#### If you see 404 errors for assets:
```
Failed: /assets/assets/finallogo.png (404)
```
- Assets aren't being served correctly
- Check vercel.json routing

#### If you see CORS errors:
```
Access to image blocked by CORS policy
```
- CORS headers missing
- Check vercel.json headers section

#### If images load but don't display:
```
Image loaded but shows broken icon
```
- File might be corrupted
- Check file format (PNG, JPG, etc.)

## Quick Test URLs

After deployment, test these URLs directly:

1. `https://your-app.vercel.app/assets/assets/finallogo.png`
2. `https://your-app.vercel.app/assets/assets/hsnc_logo.png`
3. `https://your-app.vercel.app/manifest.json`

If these return 404, the routing is broken.
If these load, but images don't show in app, it's a Flutter issue.

## Current Configuration

### vercel.json routing:
```json
"routes": [
  { "handle": "filesystem" },  // Serve files first
  { "src": "/(.*)", "dest": "/index.html" }  // Fallback to SPA
]
```

This means:
1. Check if file exists → serve it
2. If not → serve index.html (for SPA routing)

## What I Fixed

1. ✅ Removed conflicting `rewrites` section
2. ✅ Added CORS headers for assets
3. ✅ Kept `handle: filesystem` to serve files first
4. ✅ Assets are in build/web/assets/

## Next Steps

1. Push the updated vercel.json
2. Wait for Vercel to redeploy (~1 min)
3. Test the URLs above
4. Check browser console for errors
5. If still broken, share the exact error message
