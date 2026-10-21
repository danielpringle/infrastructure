FROM nginx:1.27-alpine

# Replace the default Nginx virtual host with our WordPress configuration.
COPY docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template

# Local SSL certificates are mounted at runtime rather than baked into the image.
RUN mkdir -p /etc/nginx/ssl

EXPOSE 80 443