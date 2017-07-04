FROM openjdk

MAINTAINER Florian JUDITH <florian.judith.b@gmail.com>

ENV VERSION 3.2.0
ENV RED5_HOME /opt/apache-openmeetings
ENV TERM=xterm

COPY assets/om_ad.cfg $RED5_HOME/webapps/openmeetings/conf/

RUN mkdir -p $RED5_HOME && \
    cd $RED5_HOME && \
    wget http://archive.apache.org/dist/openmeetings/$VERSION/bin/apache-openmeetings-$VERSION.tar.gz && \
    tar zxf apache-openmeetings-$VERSION.tar.gz

RUN cat /etc/apt/sources.list | sed 's/^deb\s/deb-src /g' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        slapd \
        dialog \
        ldap-utils \
        libreoffice \
        ffmpeg \
        ghostscript \
        imagemagick \
        sox \
        xmlstarlet

RUN dpkg-reconfigure slapd

# swftools
COPY assets/jpeg.patch /tmp/jpeg.patch

RUN apt-get install -y make g++ patch zlib1g-dev libgif-dev

RUN cd /tmp && \
    wget http://www.swftools.org/swftools-2013-04-09-1007.tar.gz && \
    wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz && \
    wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz

RUN cd /tmp && tar zxf freetype-2.4.0.tar.gz && \
    tar zxf jpegsrc.v9a.tar.gz && \
    tar zxf swftools-2013-04-09-1007.tar.gz

RUN cd /tmp/jpeg-9a && \
    ./configure && make && make install

RUN cd /tmp/freetype-2.4.0 && \
    ./configure && make && make install

RUN cd /tmp && ldconfig -v && \
    patch -p0 < /tmp/jpeg.patch && \
    cd swftools-2013-04-09-1007 && \
    ./configure && make && make install && \
    ranlib /usr/local/lib/libjpeg.a && ldconfig /usr/local/lib

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
RUN rm -f apache-openmeetings-$VERSION.tar.gz && \
    rm -rf /tmp/swftools* && \
    rm -rf /tmp/jpeg* && \ 
    rm -rf /tmp/freetype* && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5080 1935 8081 8100 8088 8443 5443

WORKDIR $RED5_HOME

ENTRYPOINT ["/docker-entrypoint.sh"]
