# containermon

**containermon serves a few monitoring tools with HTTPS**
* **webdav** is a file server which comes in very handy for uploading files per curl (in example from rancher or kuberntes containers). https://github.com/BytemarkHosting/docker-webdav
* **glances** is a top-like process and ressource monitoring. https://github.com/nicolargo/glances
* **dozzle** is a very easy container log. https://github.com/amir20/dozzle
* **netdata** is a high-fidelity infrastructure monitoring. https://github.com/netdata/netdata  


**quick start**
1. clone the repository to your host
2. adapt the .env file to refer to a certificate as cert.pem
3. start the stack: `docker-compose up -d`

You can find webdav on port **9997**, glances on port **9998**, dozzle on **9999** and netdata on **10000**

If you want to disable the basic auth. remove this part from haproxy.cfg for all services:
```
  acl auth_ok http_auth(authenticated)
  http-request auth realm haproxy_basic_auth unless auth_ok
```
