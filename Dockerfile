#wine PWIZ ready container to access vendor files
FROM i386/alpine:3.4

LABEL software="ProteoWizard"
LABEL software.version="3.0.4323"
LABEL website="http://proteowizard.sourceforge.net/"
LABEL documentation="http://proteowizard.sourceforge.net/win_build.shtml"
LABEL tags="Proteomics"
MAINTAINER Mathias Walzer <walzer@ebi.ac.uk>

# get wine
RUN apk update
RUN apk add "wine=1.8.2-r0" "freetype"

ENV HOME /utils
ENV WINEPREFIX /utils/.wine
ENV WINEARCH win32
ENV WINEDEBUG -all

RUN mkdir /utils
COPY autoconvert.sh /utils/autoconvert.sh
RUN chmod u+x /utils/autoconvert.sh
COPY singularity.autoconvert.sh /utils/singularity.autoconvert.sh
RUN chmod u+x /utils/singularity.autoconvert.sh

ENV WINEPATH "C:\Program Files\ProteoWizard\ProteoWizard 3.0.4323"

CMD /bin/sh
