#!/bin/bash

# Setup script for containermon with automatic SSL certificates

set -e

echo "🚀 Setting up containermon with automatic SSL certificates..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "📝 Please copy .env.example to .env and configure your settings:"
    echo "   cp .env.example .env"
    echo "   nano .env"
    exit 1
fi

# Load environment variables
source .env

# Check required variables
if [ -z "$DOMAIN" ] || [ -z "$CERTBOT_EMAIL" ] || [ -z "$LOGINNAME" ] || [ -z "$PASSWORD" ]; then
    echo "❌ Missing required environment variables!"
    echo "Please ensure DOMAIN, CERTBOT_EMAIL, LOGINNAME, and PASSWORD are set in .env"
    exit 1
fi

echo "✅ Environment variables loaded"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p certs webroot dav

# Set proper permissions
chmod 755 certs webroot dav

echo "🔧 Starting services..."

# Start nginx-challenge first (needed for certificate validation)
echo "🌐 Starting nginx challenge server..."
docker compose up -d nginx-challenge

# Wait a moment for nginx to start
sleep 5

# Get initial certificate
echo "🔐 Obtaining SSL certificate for $DOMAIN..."
docker compose run --rm certbot

# Start all services
echo "🚀 Starting all services..."
docker compose up -d

echo "✅ Setup complete!"
echo ""
echo "📋 Your services are now available at:"
echo "   • WebDAV: https://$DOMAIN:9997"
echo "   • Glances: https://$DOMAIN:9998"
echo "   • Dozzle: https://$DOMAIN:9999"
echo "   • Netdata: https://$DOMAIN:10000"
echo ""
echo "🔐 SSL certificates will be automatically renewed every 12 hours"
echo "📧 Certificate expiration notifications will be sent to: $CERTBOT_EMAIL"
echo ""
echo "🔍 To check certificate status:"
echo "   docker compose logs certbot"
echo ""
echo "🔄 To manually renew certificates:"
echo "   docker compose run --rm certbot renew"
