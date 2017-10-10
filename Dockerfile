FROM rocker/rstudio

RUN apt-get update && apt-get install -y libxml2-dev zlib1g-dev openjdk-8-jdk lzma-dev libpcre2-dev libbz2-dev libpcre++-dev liblzma-dev
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("BiocInstaller")'
RUN install2.r --error RJDBC devtools DescTools tidyverse
RUN install2.r --error knitr rmarkdown formatR

RUN export ADD=shiny && bash /etc/cont-init.d/add

ADD ./vertica-*.jar /home/rstudio
ADD ./piR_0.2.1.tar.gz /home/rstudio
RUN install2.r --error roxygen2 testthat shinycssloaders shinythemes

RUN sed -i '/site_dir/c\app_dir /srv/shiny-server/pilab;' /etc/shiny-server/shiny-server.conf
RUN mkdir /srv/shiny-server/devcamp && chmod 777 /srv/shiny-server/devcamp && ln -s /srv/shiny-server/devcamp /home/rstudio/shiny
ADD ./R /home/rstudio/shiny
RUN service shiny-server reload
