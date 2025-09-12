FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/default /etc/nginx/sites-available/

# Optional: symlink if needed (some base configs require this)
#RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Make sure certs directory exists (but will be mounted at runtime)
RUN mkdir -p /etc/nginx/ssl

# Expose port 443
EXPOSE 443

# Start nginx in foreground (PID 1)
CMD ["nginx", "-g", "daemon off;"]

