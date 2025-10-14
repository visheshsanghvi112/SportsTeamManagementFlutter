# Firebase Setup for Vercel Deployment

## Important: Authorize Your Vercel Domain in Firebase

After deploying to Vercel, you **MUST** authorize your Vercel domain in Firebase Console to allow authentication to work.

### Steps to Authorize Domain:

1. **Deploy to Vercel first** and get your URL (e.g., `your-app.vercel.app`)

2. **Go to Firebase Console**:
   - Visit: https://console.firebase.google.com
   - Select project: `teamapp-da9d9`

3. **Add Authorized Domain**:
   - Navigate to: **Authentication** → **Settings** → **Authorized domains**
   - Click **Add domain**
   - Enter your Vercel domain: `your-app.vercel.app`
   - Click **Add**

4. **If using custom domain**:
   - Also add your custom domain (e.g., `yourdomain.com`)
   - Add both `www.yourdomain.com` and `yourdomain.com` if needed

### Current Firebase Configuration

**Project ID**: `teamapp-da9d9`

**Services Configured**:
- ✅ Firebase Authentication
- ✅ Cloud Firestore
- ✅ Firebase Storage
- ✅ Realtime Database
- ✅ Firebase Analytics

**Auth Domain**: `teamapp-da9d9.firebaseapp.com`

### Firebase Security Rules

Make sure you have proper security rules set up:

#### Firestore Rules (Example)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add your specific rules here
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Storage Rules (Example)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

#### Realtime Database Rules (Example)
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

### Authentication Methods

Enable the authentication methods you need in Firebase Console:

1. Go to **Authentication** → **Sign-in method**
2. Enable required providers:
   - ✅ Email/Password
   - ✅ Google Sign-In
   - ✅ Facebook Login (if configured)
   - ✅ Phone Authentication (if needed)

### Important Notes

⚠️ **Security Warning**: The Firebase config in `firebase_options.dart` contains public API keys. This is **normal and safe** for web apps. Firebase security is enforced through:
- Security Rules (Firestore, Storage, Database)
- Authentication requirements
- Domain authorization

✅ **What's Already Done**:
- Firebase initialized in `main.dart`
- Error handling implemented
- Analytics enabled
- All Firebase packages included

❌ **What You Need to Do**:
1. Authorize Vercel domain in Firebase Console (after deployment)
2. Review and update security rules
3. Enable required authentication methods
4. Test all Firebase features after deployment

### Testing Firebase Connection

After deployment, test these features:

1. **Authentication**:
   - Sign up with email/password
   - Login with existing account
   - Google Sign-In (if enabled)
   - Password reset

2. **Firestore**:
   - Read data
   - Write data
   - Real-time updates

3. **Storage**:
   - Upload files
   - Download files
   - View images

4. **Analytics**:
   - Check Firebase Console → Analytics
   - Verify events are being logged

### Troubleshooting

#### Error: "This domain is not authorized"
**Solution**: Add your Vercel domain to Firebase authorized domains (see steps above)

#### Error: "Permission denied" in Firestore
**Solution**: Check your Firestore security rules, ensure user is authenticated

#### Error: "Firebase not initialized"
**Solution**: Check browser console, verify `firebase_options.dart` is correct

#### Authentication not working
**Solution**: 
1. Check authorized domains in Firebase Console
2. Verify authentication method is enabled
3. Check browser console for errors

### Firebase Console Links

- **Project Overview**: https://console.firebase.google.com/project/teamapp-da9d9
- **Authentication**: https://console.firebase.google.com/project/teamapp-da9d9/authentication
- **Firestore**: https://console.firebase.google.com/project/teamapp-da9d9/firestore
- **Storage**: https://console.firebase.google.com/project/teamapp-da9d9/storage
- **Analytics**: https://console.firebase.google.com/project/teamapp-da9d9/analytics

### Post-Deployment Checklist

After deploying to Vercel:

- [ ] Add Vercel domain to Firebase authorized domains
- [ ] Test user authentication
- [ ] Verify Firestore read/write operations
- [ ] Test file uploads to Storage
- [ ] Check Analytics in Firebase Console
- [ ] Review security rules
- [ ] Test on mobile devices
- [ ] Verify PWA installation works

## Need Help?

If you encounter issues:
1. Check browser console for errors
2. Review Firebase Console logs
3. Check Vercel deployment logs
4. Verify all domains are authorized
5. Ensure security rules allow your operations
