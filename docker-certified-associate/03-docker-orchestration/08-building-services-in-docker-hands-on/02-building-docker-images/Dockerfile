# ---- Base Stage ----
FROM nginx:1.15.8 as base

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# ---- Fruit Stage ----
FROM base as fruit

# Copy the JSON file into the container
COPY fruit-list/static/fruit.json /usr/share/nginx/html

# Copy the custom Nginx configuration into the container
COPY fruit-list/nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when container is launched
CMD ["nginx", "-g", "daemon off;"]

# ---- Vegetable Stage ----
FROM base as vegetable

# Copy the JSON file into the container
COPY vegetable-list/static/vegetable.json /usr/share/nginx/html

# Copy the custom Nginx configuration into the container
COPY vegetable-list/nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when container is launched
CMD ["nginx", "-g", "daemon off;"]
