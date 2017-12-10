#PWIZ non-public container image facilitating wine to access vendor files
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
#	apk add "xvfb" "ncurses-libs" "ca-certificates" "openssl" && \
#	update-ca-certificates && \
#	wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
#	chmod ugo+x winetricks && mv winetricks /usr/local/bin && \

#dedicated user for running wine 
	addgroup -S -g 989 docker && \
	adduser -S -u 1001 -g docker wine 

ENV HOME /home/wine
ENV WINEPREFIX /home/wine/.wine
ENV WINEARCH win32
ENV WINEDEBUG -all

#COPY wine_pwiz_4323-anonym /home/wine/.wine
#RUN chown -R wine:docker /home/wine/.wine
COPY autoconvert.sh /home/wine/autoconvert.sh
RUN chown -R wine:docker /home/wine/autoconvert.sh && chmod u+x /home/wine/autoconvert.sh

USER wine
#RUN winetricks corefonts

ENV WINEPATH "C:\Program Files\ProteoWizard\ProteoWizard 3.0.4323"
#ENV DISPLAY :0

CMD /bin/sh
