#!/bin/sh

# install deps
sudo apt-get -y --force-yes install \
    autoconf automake build-essential libass-dev libfreetype6-dev \
    libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev

# prepare build folders
mkdir -p /tmp/ffmpeg/sources
mkdir -p /tmp/ffmpeg/build
mkdir -p /tmp/ffmpeg/bin

# h264
sudo apt-get install libx264-dev
# mp3
sudo apt-get install libmp3lame-dev

# compile
cd /tmp/ffmpeg/sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PKG_CONFIG_PATH="/tmp/ffmpeg/build/lib/pkgconfig" ./configure \
    --prefix="/tmp/ffmpeg/build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I/tmp/ffmpeg/build/include" \
    --extra-ldflags="-L/tmp/ffmpeg/build/lib" \
    --bindir="/tmp/ffmpeg/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libx264 \
    --enable-nonfree
make
make install

# copy bin (backup old)
sudo mv /opt/ffmpeg /opt/ffmpeg.old
sudo mv /opt/ffprobe /opt/ffprobe.old
sudo cp /tmp/ffmpeg/bin/ff{mpeg,probe} /opt

# cleanup
rm -rf /tmp/ffmpeg
