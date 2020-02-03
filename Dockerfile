FROM adnrv/texlive:full

COPY out/pandoc* /usr/bin/
ENV USE_PANDOC_IN_PATH=1
RUN apt-get -y update && apt-get install -y inkscape
