#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the instance's private IP
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
NAME="Kevin"  # Replace with your name
ENV="non-prod"

# Create custom web content
cat > /var/www/html/index.html <<EOF
<html>
<body>
<h1>Hello, I am ${NAME} in ${ENV} environment. My private IP is ${PRIVATE_IP}</h1>
</body>
</html>
EOF