#!/bin/bash
# setup NAT
dnf install iptables-services -y
systemctl enable --now iptables
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
/sbin/iptables -t nat -A POSTROUTING -o $(ip -br l | awk '$1 !~ "lo|vir|wl" { print $1}') -j MASQUERADE
/sbin/iptables -F FORWARD
/sbin/iptables -F INPUT 
service iptables save

# install nginx
dnf install nginx -y
systemctl enable --now nginx

# generate tls certificates with certbot
dnf install certbot python3-certbot-nginx -y
certbot --agree-tos --register-unsafely-without-email -d ${domain} -d www.${domain}

# configure nginx reverse proxy for jenkins in private subnet
cat <<EOF > /etc/nginx/conf.d/jenkins-reverse-proxy.conf
server {
  listen 80;
  server_name _;

  return 301 https://\$host\$request_uri;
}

server {
  listen 443 ssl;
  server_name ${domain}; 

  ssl_certificate /etc/letsencrypt/live/${domain}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;

  location / {
    proxy_pass http://${k3s_server_private_ip}:${jenkins_nodeport}; 
    proxy_set_header Host \$host;  
    proxy_set_header X-Real-IP \$remote_addr; 
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; 
    proxy_set_header X-Forwarded-Proto \$scheme;

    error_page 502 = @custom_502;
  }

  location @custom_502 {
    default_type text/html;
    return 502 "<html><body><h1>Jenkins is loading ...</h1><em>Please wait and check back later ...</em></body></html>";
  }
}
EOF

nginx -t
systemctl restart nginx
