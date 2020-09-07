FROM nginx

# Create working directory
WORKDIR /var/www/html

# Copy built folder
COPY index.html ./

# Copy nginx conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
