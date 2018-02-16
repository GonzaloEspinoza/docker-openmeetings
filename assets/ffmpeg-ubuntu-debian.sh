# FFmpeg compilation for Ubuntu 17.04 and Debian 9 only.
# Alvaro Bustos. Thanks to Hunter.
# Updated 8-12-2017

 apt-get update
 apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev mercurial cmake libx264-dev libx265-dev libfdk-aac-dev libmp3lame-dev libvpx-dev libmp3lame-devel

# Create a directory for sources.
SOURCES=$(mkdir ~/ffmpeg_sources)
cd ~/ffmpeg_sources

# Download the necessary sources.
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
hg clone https://bitbucket.org/multicoreware/x265
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
# wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
wget http://ffmpeg.org/releases/ffmpeg-3.4.1.tar.gz

# Unpack files
for file in `ls ~/ffmpeg_sources/*.tar.*`; do
tar -xvf $file
done

cd yasm-*/
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && make &&  make install && make distclean; cd ..

cd x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && make &&  make install && make distclean; cd ~/ffmpeg_sources

cd mstorsjo-fdk-aac*
autoreconf -fiv && ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && make &&  make install && make distclean; cd ..

cd ffmpeg-*/
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --pkg-config-flags="--static" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-nonfree && PATH="$HOME/bin:$PATH" make &&  make install && make distclean && hash -r; cd ..

cd ~/bin
cp ffmpeg ffprobe ffserver vsyasm yasm ytasm /usr/local/bin

cd ~/ffmpeg_build/bin
cp x265 /usr/local/bin

echo "FFmpeg Compilation is Finished!"

