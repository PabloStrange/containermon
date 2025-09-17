# SSL Certificate Setup with Certbot

This setup automatically manages SSL certificates using Let's Encrypt and Certbot, so you don't need to manually handle SSL certificates.

## DNS Configuration Required

Before starting, you need to configure your DNS records. Here's what you need to set up:

### Required DNS Records

1. **A Record**: Point your domain to your server's public IP address
   ```
   Type: A
   Name: your-domain.com (or @)
   Value: YOUR_SERVER_PUBLIC_IP
   TTL: 300 (or default)
   ```

2. **Optional - Subdomain Records**: If you want separate subdomains for each service:
   ```
   Type: A
   Name: webdav.your-domain.com
   Value: YOUR_SERVER_PUBLIC_IP
   
   Type: A
   Name: glances.your-domain.com
   Value: YOUR_SERVER_PUBLIC_IP
   
   Type: A
   Name: dozzle.your-domain.com
   Value: YOUR_SERVER_PUBLIC_IP
   
   Type: A
   Name: netdata.your-domain.com
   Value: YOUR_SERVER_PUBLIC_IP
   ```

### Important Notes:
- **Port 80 must be open** on your server for the HTTP challenge to work
- **Port 443 must be open** for HTTPS traffic
- DNS propagation can take up to 24 hours, but usually works within minutes
- You can test DNS resolution with: `nslookup your-domain.com`

## Quick Setup

1. **Configure your environment**:
   ```bash
   cp .env.example .env
   nano .env
   ```

2. **Set your domain and email** in `.env`:
   ```
   DOMAIN=your-domain.com
   CERTBOT_EMAIL=your-email@example.com
   LOGINNAME=admin
   PASSWORD=your-secure-password
   ```

3. **Run the setup script**:
   ```bash
   ./setup.sh
   ```

## Manual Setup (Alternative)

If you prefer to set up manually:

1. **Create directories**:
   ```bash
   mkdir -p certs webroot dav
   ```

2. **Start nginx challenge server**:
   ```bash
   docker-compose up -d nginx-challenge
   ```

3. **Obtain SSL certificate**:
   ```bash
   docker-compose run --rm certbot
   ```

4. **Start all services**:
   ```bash
   docker-compose up -d
   ```

## How It Works

### Certificate Management
- **Certbot** automatically obtains SSL certificates from Let's Encrypt
- **HTTP Challenge**: Uses port 80 to validate domain ownership
- **Auto-renewal**: Certificates are renewed every 12 hours automatically
- **Certificate Location**: `/certs/live/your-domain.com/`

### Services Architecture
```
Internet → HAProxy (Port 443) → Your Services
         ↓
    nginx-challenge (Port 80) → Certbot validation
```

### Port Configuration
- **Port 80**: HTTP challenge server (nginx)
- **Port 443**: HTTPS traffic (HAProxy)
- **Port 9997**: WebDAV (HTTPS)
- **Port 9998**: Glances (HTTPS)
- **Port 9999**: Dozzle (HTTPS)
- **Port 10000**: Netdata (HTTPS)

## Troubleshooting

### Certificate Issues
```bash
# Check certificate status
docker-compose logs certbot

# Manually renew certificates
docker-compose run --rm certbot renew

# Check certificate files
ls -la certs/live/your-domain.com/
```

### DNS Issues
```bash
# Test DNS resolution
nslookup your-domain.com
dig your-domain.com

# Check if port 80 is accessible
curl -I http://your-domain.com
```

### Service Issues
```bash
# Check all services
docker-compose ps

# View logs
docker-compose logs haproxy
docker-compose logs nginx-challenge

# Restart services
docker-compose restart
```

## Security Notes

- Certificates are automatically renewed before expiration
- HTTP traffic is redirected to HTTPS
- Strong SSL ciphers are configured in HAProxy
- Basic authentication is enabled for monitoring services
- Let's Encrypt rate limits: 50 certificates per registered domain per week

## Monitoring

- Check certificate expiration: `docker-compose exec certbot certbot certificates`
- View renewal logs: `docker-compose logs certbot-renewal`
- Monitor service health: `docker-compose ps`

## Backup

Important files to backup:
- `certs/` directory (contains your SSL certificates)
- `.env` file (contains your configuration)
- `dav/` directory (contains your WebDAV files)