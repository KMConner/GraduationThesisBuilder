FROM adnrv/texlive:full

COPY out/pandoc* /usr/bin/
ENV USE_PANDOC_IN_PATH=1
