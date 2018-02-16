FROM openjdk:8u151-jdk

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ENV VERSION=4.0.1
ENV RED5_HOME=/opt/apache-openmeetings
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive
COPY assets/om_ad.cfg $RED5_HOME/webapps/openmeetings/conf/

RUN mkdir -p $RED5_HOME && \
    cd $RED5_HOME && \
    wget http://apache.crihan.fr/dist/openmeetings/$VERSION/bin/apache-openmeetings-$VERSION.tar.gz && \
    tar zxf apache-openmeetings-$VERSION.tar.gz

RUN cat /etc/apt/sources.list | sed 's/^deb\s/deb-src /g' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        icedtea-8-plugin \
        ldap-utils \
        libreoffice \
        ffmpeg \
        ghostscript \
        imagemagick \
        libjpeg62 \
        zlib1g-dev \
        unzip \
        make \
        build-essential \
        wget \
        nmap \
        xmlstarlet

# RUN dpkg-reconfigure slapd

# sox
RUN cd /opt && \
    wget http://sourceforge.net/projects/sox/files/sox/14.4.2/sox-14.4.2.tar.gz && \
    tar xzvf sox-14.4.2.tar.gz && \
    cd /opt/sox-14.4.2 && \
    ./configure && \
    make && \
    make install && \
    ldconfig

# flashplayer
RUN cd /opt && \
    mkdir flashplayer && \
    cd flashplayer && \
    wget http://slackware.uk/people/alien/slackbuilds/flashplayer-plugin/build/flash_player_npapi_linux.28.0.0.161.x86_64.tar.gz && \
    tar zxvf flash_player_npapi_linux.28.0.0.161.x86_64.tar.gz && \
    mkdir -p /home/root/.mozilla/plugins && \
    cp libflashplayer.so /home/root/.mozilla/plugins




# swftools
# COPY assets/jpeg.patch /tmp/jpeg.patch

# RUN apt-get install -y make g++ patch zlib1g-dev libgif-dev

# RUN cd /tmp && \
#     wget http://www.swftools.org/swftools-2013-04-09-1007.tar.gz && \
#     wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.0.tar.gz && \
#     wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz

# RUN cd /tmp && tar zxf freetype-2.4.0.tar.gz && \
#     tar zxf jpegsrc.v9a.tar.gz && \
#     tar zxf swftools-2013-04-09-1007.tar.gz

# RUN cd /tmp/jpeg-9a && \
#     ./configure && make && make install

# RUN cd /tmp/freetype-2.4.0 && \
#     ./configure && make && make install

# RUN cd /tmp && ldconfig -v && \
#     patch -p0 < /tmp/jpeg.patch && \
#     cd swftools-2013-04-09-1007 && \
#     ./configure && make && make install && \
#     ranlib /usr/local/lib/libjpeg.a && ldconfig /usr/local/lib

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
