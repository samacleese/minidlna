#!/bin/bash
PATH=/usr/bin:/usr/local/bin:$PATH
command -v convert >/dev/null 2>&1 || { echo >&2 "Please install imagemagick"; exit 1; }
command -v xxd >/dev/null 2>&1 || { echo >&2 "Please install xd"; exit 1; }
if [ -z "$1" ]; then
        echo "Usage: $0 imagefile"
        exit 1
fi
if [ ! -f $1 ]; then
        echo "Image does not exist"
        exit 1
fi
if [ -f icons.c ]; then
        mv icons.c icons.c_bak
fi
convert $1 -resize 40x40\! tmp_png_sm.png
convert $1 -flatten -resize 40x40\! tmp_jpeg_sm.jpeg
convert $1 -resize 120x120\! tmp_png_lrg.png
convert $1 -flatten  -resize 120x120\! tmp_jpeg_lrg.jpeg
xxd -p -c 24 tmp_png_sm.png | sed -e '    s/../\\x&/g' \
        -e '1   s/^/unsigned char png_sm\[\] =  "/' \
        -e '1 ! s/^/             "/' \
        -e '    s/$/"/' \
        -e '$   s/$/;/' >> icons.c
xxd -p -c 24 tmp_jpeg_sm.jpeg | sed -e '    s/../\\x&/g' \
        -e '1   s/^/unsigned char jpeg_sm\[\] =  "/' \
        -e '1 ! s/^/             "/' \
        -e '    s/$/"/' \
        -e '$   s/$/;/' >> icons.c
xxd -p -c 24 tmp_png_lrg.png | sed -e '    s/../\\x&/g' \
        -e '1   s/^/unsigned char png_lrg\[\] =  "/' \
        -e '1 ! s/^/             "/' \
        -e '    s/$/"/' \
        -e '$   s/$/;/' >> icons.c
xxd -p -c 24 tmp_jpeg_lrg.jpeg | sed -e '    s/../\\x&/g' \
        -e '1   s/^/unsigned char jpeg_lrg\[\] =  "/' \
        -e '1 ! s/^/             "/' \
        -e '    s/$/"/' \
        -e '$   s/$/;/' >> icons.c
rm tmp_*jpeg tmp_*png
