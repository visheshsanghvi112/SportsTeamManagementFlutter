# Deployment Guide - Sports Team Management App

## Overview
This Flutter web app is configured to deploy to Vercel with Firebase backend integration.

## Prerequisites
- Vercel account (free tier works)
- Git repository (GitHub, GitLab, or Bitbucket)

## Deployment Steps

### Option 1: Deploy via Vercel CLI (Recommended)

1. **Install Vercel CLI** (if not already installed):
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**:
   ```bash
   vercel login
   ```

3. **Deploy from project directory**:
   ```bash
   cd /Users/vishesh/Downloads/SportsTeamManagementFlutter
   vercel
   ```

4. **Follow the prompts**:
   - Set up and deploy? **Y**
   - Which scope? Select your account
   - Link to existing project? **N** (first time)
   - Project name? Use default or customize
   - Directory? `.` (current directory)
   - Override settings? **N**

5. **Production deployment**:
   ```bash
   vercel --prod
   ```

### Option 2: Deploy via Vercel Dashboard

1. **Push to Git**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit for Vercel deployment"
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **Import to Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Click "Add New Project"
   - Import your Git repository
   - Vercel will auto-detect the `vercel.json` configuration
   - Click "Deploy"

## Configuration Files

### `vercel.json`
- **buildCommand**: Builds the Flutter web app using local Flutter SDK
- **outputDirectory**: Points to `build/web` where Flutter outputs the web build
- **rewrites**: Ensures all routes redirect to `index.html` for SPA routing

### `.vercelignore`
- Excludes unnecessary files (Android/iOS folders, IDE files, etc.)
- Keeps deployment lean and fast

## Firebase Configuration

The app is already configured with Firebase:
- **Auth**: Firebase Authentication
- **Firestore**: Cloud Firestore database
- **Storage**: Firebase Storage
- **Analytics**: Firebase Analytics

All Firebase credentials are in `lib/firebase_options.dart` with web-specific config.

## Post-Deployment

After deployment, you'll get a URL like:
```
https://your-project-name.vercel.app
```

### Custom Domain (Optional)
1. Go to your Vercel project dashboard
2. Navigate to "Settings" → "Domains"
3. Add your custom domain
4. Update DNS records as instructed

## Rebuilding

To rebuild and redeploy:

```bash
# Build locally
./flutter/bin/flutter build web --release

# Deploy to Vercel
vercel --prod
```

Or simply push to your Git repository if using Git integration - Vercel will auto-deploy.

## Troubleshooting

### Build fails on Vercel
- Ensure Flutter SDK is available in the build environment
- Check build logs in Vercel dashboard
- Verify `vercel.json` paths are correct

### Firebase not working
- Check browser console for errors
- Verify Firebase config in `firebase_options.dart`
- Ensure Firebase project is active in Firebase Console

### Routing issues
- The `rewrites` rule in `vercel.json` handles SPA routing
- All routes redirect to `index.html`

## Environment Variables

If you need to add environment variables:
1. Go to Vercel project settings
2. Navigate to "Environment Variables"
3. Add variables (e.g., API keys, feature flags)

## Support

For issues:
- Check Vercel build logs
- Review Firebase Console for backend errors
- Test locally with `./flutter/bin/flutter run -d chrome`
