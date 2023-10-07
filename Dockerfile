FROM php:7.4-apache
LABEL org.opencontainers.image.authors="davide.lanza@eikonproject.org"
LABEL org.opencontainers.image.description "Apache on PHP 7.4 Development Docker Image"

# Set global servername in apache2.conf
# Enable rewrite module
# Disabe default virtualhost
RUN echo "ServerName website.local" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2dissite 000-default

# Copy configuration file for "website.local" website
COPY apache.conf /etc/apache2/sites-available/website.local.conf

# Set workdir to /home/htdocs (the apache DocumentRoot)
RUN mkdir -p /home/htdocs && \
    chown -R $USER:$USER /home/htdocs && \
    chmod -R 755 /home/htdocs
WORKDIR /home/htdocs

# Enable website.local virtualhost
RUN a2ensite website.local

# Expose website.local port (set in website.local.conf)
EXPOSE 80

# Restart apache to apply changes
RUN service apache2 restart
