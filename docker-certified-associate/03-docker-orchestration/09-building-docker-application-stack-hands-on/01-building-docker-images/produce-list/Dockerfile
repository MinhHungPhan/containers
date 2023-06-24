# Base Image
FROM nginx:1.15.8

# Copy static file to nginx html directory
COPY static/produce.json /usr/share/nginx/html/produce.json

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when the container has provisioned.
CMD ["nginx", "-g", "daemon off;"]
