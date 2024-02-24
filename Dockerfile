# Use shiny image
FROM --platform=linux/amd64 rocker/shiny:latest

# Update system libraries
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libcurl4-openssl-dev \
    libssl-dev

# Set shiny working directory
RUN rm -rf /srv/shiny-server/*
WORKDIR /srv/shiny-server/

# Copy Shiny files
COPY /app.R ./app.R

# Expose port
EXPOSE 3838