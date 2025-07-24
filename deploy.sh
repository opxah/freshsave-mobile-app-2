#!/bin/bash

# FreshSave App Deployment Script

echo "🚀 Starting FreshSave App Deployment..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

# Check if Expo CLI is installed
if ! command -v expo &> /dev/null; then
    echo "📦 Installing Expo CLI..."
    npm install -g @expo/cli
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if AWS configuration is set up
if [ ! -f "src/services/aws-config.ts" ]; then
    echo "❌ AWS configuration file not found. Please set up AWS configuration first."
    echo "📖 See AWS_SETUP.md for detailed instructions."
    exit 1
fi

# Check if AWS credentials are configured
echo "🔧 Checking AWS configuration..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "⚠️  AWS credentials not configured. Please run 'aws configure' first."
    echo "📖 See AWS_SETUP.md for detailed instructions."
fi

# Build the app
echo "🔨 Building the app..."
npx expo build

# Check build status
if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi

# Start the development server
echo "🌐 Starting development server..."
echo "📱 You can now run the app on your device or simulator:"
echo "   - iOS: npm run ios"
echo "   - Android: npm run android"
echo "   - Web: npm run web"
echo ""
echo "🔗 Expo DevTools will open in your browser"
echo "📱 Scan the QR code with Expo Go app on your phone"

# Start Expo development server
npx expo start 