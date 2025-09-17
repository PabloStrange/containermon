# containermon

**containermon serves a few monitoring tools with automatic HTTPS SSL certificates and a unified dashboard**

* **webdav** (Stackfile by Bytemark) is a file server which comes in very handy for file transfers (in example from rancher or kuberntes containers using curl). https://github.com/BytemarkHosting/docker-webdav
* **glances** is a top-like process and ressource monitoring. https://github.com/nicolargo/glances
* **dozzle** is a very easy container log. https://github.com/amir20/dozzle
* **netdata** is a high-fidelity infrastructure monitoring. https://github.com/netdata/netdata  

## 🚀 Quick Start with Automatic SSL

1. **Set up DNS**: Point your monitoring domain to your server's public IP (see [SSL_SETUP.md](SSL_SETUP.md) for details)
2. **Configure environment**: `cp .env.example .env` and edit with your domain and email
3. **Run setup**: `./setup.sh`

Your services will be available at:
- **Main Dashboard**: https://monitoring.your-domain.com
- **WebDAV**: https://monitoring.your-domain.com/webdav
- **Glances**: https://monitoring.your-domain.com/glances  
- **Dozzle**: https://monitoring.your-domain.com/dozzle
- **Netdata**: https://monitoring.your-domain.com/netdata

## 🔐 SSL Certificate Management

This setup includes **automatic SSL certificate management** using Let's Encrypt and Certbot:
- ✅ Automatic certificate generation
- ✅ Auto-renewal every 12 hours
- ✅ No manual certificate management needed
- ✅ HTTP challenge validation
- ✅ Strong SSL ciphers configured

## 📋 DNS Requirements

You need to set up these DNS records:
```
Type: A
Name: monitoring.your-domain.com
Value: YOUR_SERVER_PUBLIC_IP
```

**Important**: Port 80 must be open for certificate validation.

## 🎯 New Unified Dashboard

The new setup includes a beautiful dashboard that provides easy access to all your monitoring tools:

- **Single Domain**: All services are now accessible under one domain (e.g., `monitoring.your-domain.com`)
- **Path-based Routing**: Services are accessed via paths (e.g., `/dozzle`, `/glances`, `/netdata`, `/webdav`)
- **Modern UI**: Clean, responsive dashboard with service descriptions and easy navigation
- **Secure**: All services maintain their authentication and SSL protection

## 🔧 Manual Setup (Legacy)

If you prefer manual certificate management:
1. Clone the repository to your host
2. Adapt the .env file to refer to a certificate as cert.pem
3. Start the stack: `docker-compose up -d`

## 🔒 Authentication

Basic authentication is enabled for monitoring services (glances, dozzle, netdata). WebDAV has its own authentication system. The main dashboard is publicly accessible.

To disable authentication for specific services, remove these lines from haproxy.cfg for the desired service:
```
  acl auth_ok http_auth(authenticated)
  http-request auth realm haproxy_basic_auth unless auth_ok
```

## 📚 Documentation

- [SSL Setup Guide](SSL_SETUP.md) - Detailed SSL certificate setup instructions
- [Troubleshooting](SSL_SETUP.md#troubleshooting) - Common issues and solutions

## ⚠️ Disclaimer

I did not create any of these applications. This setup combines existing open-source tools with automatic SSL certificate management. 
