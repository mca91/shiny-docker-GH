# Use shiny image
FROM rocker/shiny:4.3.0

# Update system libraries
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libcurl4-openssl-dev \
    libssl-dev

# Set shiny working directory
RUN rm -rf /srv/shiny-server/*
WORKDIR /srv/shiny-server/

# Copy Shiny files
COPY /ui.R ./ui.R
COPY /server.R ./server.R
COPY /global.R ./global.R
COPY /R ./R
copy /www ./www

# Copy renv.lock file
COPY /renv.lock ./renv.lock

# Download renv and restore library
ENV RENV_VERSION 1.0.0
RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_github('rstudio/renv@v${RENV_VERSION}')"
ENV RENV_PATHS_LIBRARY renv/library
RUN Rscript -e 'renv::restore()'

# Expose port
EXPOSE 3838
