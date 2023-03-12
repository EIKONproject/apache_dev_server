FROM php:7.4-apache
LABEL org.opencontainers.image.authors="davide.lanza@eikonproject.org"

ARG WEBSITE_NAME=localwebsite.com
ENV WEBSITE_NAME=${WEBSITE_NAME}

# Set global servername in apache2.conf
# Enable rewrite module
# Disabe default virtualhost
RUN echo "ServerName ${WEBSITE_NAME}" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2dissite 000-default

# Copy configuration file for ${WEBSITE_NAME} website
COPY apache.conf /etc/apache2/sites-available/${WEBSITE_NAME}.conf

# Set workdir to /home/htdocs (the apache DocumentRoot)
RUN mkdir -p /home/htdocs && \
    chown -R $USER:$USER /home/htdocs && \
    chmod -R 755 /home/htdocs
WORKDIR /home/htdocs

# Enable ${WEBSITE_NAME} virtualhost
RUN a2ensite ${WEBSITE_NAME}

# Expose ${WEBSITE_NAME} port (set in ${WEBSITE_NAME}.conf)
EXPOSE 80

# Restart apache to apply changes
RUN service apache2 restart
