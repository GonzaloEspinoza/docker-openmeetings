FROM amd64/openjdk:8u151

LABEL maintainer='Florian JUDITH <florian.judith.b@gmail.com>'

ENV DEBIAN_FRONTEND="noninteractive"
ENV VERSION='4.0.0'
ENV RED5_HOME='/usr/share/apache-openmeetings'
ENV TERM='xterm'

COPY assets/om_ad.cfg ${RED5_HOME}/webapps/openmeetings/conf/

RUN mkdir -p ${RED5_HOME} && \
    cd ${RED5_HOME} && \
    wget http://apache.crihan.fr/dist/openmeetings/${VERSION}/bin/apache-openmeetings-${VERSION}.tar.gz && \
    tar zxf apache-openmeetings-${VERSION}.tar.gz

RUN cat /etc/apt/sources.list | sed 's/^deb\s/deb-src /g' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        slapd \
        ldap-utils \
        libreoffice \
        ffmpeg \
        ghostscript \
        imagemagick \
        sox \
        xmlstarlet

# RUN dpkg-reconfigure slapd

# swftools
COPY assets/jpeg.patch /tmp/jpeg.patch

RUN apt-get install -y make g++ patch zlib1g-dev libgif-dev

RUN cd /tmp && \
    wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz && \
    wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz

RUN cd /tmp && tar zxf freetype-2.4.0.tar.gz && \
    tar zxf jpegsrc.v9a.tar.gz

RUN cd /tmp/jpeg-9a && \
    ./configure && make && make install

RUN cd /tmp/freetype-2.4.0 && \
    ./configure && make && make install


# jodconverter
RUN curl -L https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/jodconverter/jodconverter-core-3.0-beta-4-dist.zip -o /opt/jodconverter-core-3.0-beta-4-dist.zip && \
    unzip /opt/jodconverter-core-3.0-beta-4-dist.zip -d /opt && \
    rm -f /opt/jodconverter-core-3.0-beta-4-dist.zip && \
    cd /opt && ln -s jodconverter-core-3.0-beta-4 jod

# ffmpeg
COPY assets/ffmpeg-ubuntu-debian.sh /tmp
RUN chmod +x /tmp/ffmpeg-ubuntu-debian.sh && \
    /tmp/ffmpeg-ubuntu-debian.sh

# Cleanup
RUN rm -f apache-openmeetings-${VERSION}.tar.gz && \
    rm -rf /tmp/jpeg* && \ 
    rm -rf /tmp/freetype* && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh ${RED5_HOME}/
RUN chmod +x ${RED5_HOME}/docker-entrypoint.sh

EXPOSE 5080 1935 8081 8100 8088 8443 5443

WORKDIR ${RED5_HOME}

ENTRYPOINT ["${RED5_HOME}/docker-entrypoint.sh"]
CMD ["${RED5_HOME}/red5.sh"]
