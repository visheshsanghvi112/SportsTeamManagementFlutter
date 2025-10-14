#!/bin/bash

# Sports Team Management App - Vercel Deployment Script
# This script automates the deployment process

set -e  # Exit on error

echo "🚀 Sports Team Management - Vercel Deployment"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Flutter is available
if [ ! -f "./flutter/bin/flutter" ]; then
    echo -e "${RED}✗ Flutter not found in ./flutter/bin/flutter${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter found${NC}"

# Check if build directory exists
if [ ! -d "build/web" ]; then
    echo -e "${YELLOW}⚠ Build directory not found. Building now...${NC}"
    ./flutter/bin/flutter build web --release
else
    echo -e "${YELLOW}? Build directory exists. Rebuild? (y/n)${NC}"
    read -r rebuild
    if [ "$rebuild" = "y" ] || [ "$rebuild" = "Y" ]; then
        echo "🔨 Building Flutter web app..."
        ./flutter/bin/flutter build web --release
    fi
fi

echo -e "${GREEN}✓ Build ready${NC}"
echo ""

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}⚠ Vercel CLI not found${NC}"
    echo "Installing Vercel CLI..."
    npm install -g vercel
fi
echo -e "${GREEN}✓ Vercel CLI ready${NC}"
echo ""

# Deployment options
echo "Choose deployment option:"
echo "1) Deploy to preview (test deployment)"
echo "2) Deploy to production"
echo "3) Cancel"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Deploying to preview..."
        vercel
        ;;
    2)
        echo ""
        echo "🚀 Deploying to production..."
        vercel --prod
        ;;
    3)
        echo "Deployment cancelled"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✓ Deployment complete!${NC}"
echo ""
echo "📋 Next Steps:"
echo "1. Visit your Vercel URL"
echo "2. Add the domain to Firebase Console → Authentication → Authorized domains"
echo "3. Test authentication and Firebase features"
echo ""
echo "📚 See FIREBASE_SETUP.md for detailed Firebase configuration"
echo "📚 See PRE_DEPLOYMENT_CHECKLIST.md for verification steps"
