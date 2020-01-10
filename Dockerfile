FROM haskell:8.6.5

RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN mkdir /work
WORKDIR /work
RUN git clone --recursive git://github.com/KMConner/GraduationThesisBuilder.git
WORKDIR /work/GraduationThesisBuilder
RUN stack update
RUN stack setup
RUN stack build
RUN mv $(stack path --local-install-root)/bin/* ../

FROM adnrv/texlive:full

COPY --from=0 /work/pandoc* /usr/bin/


