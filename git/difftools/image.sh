#!/bin/sh

if which identify > /dev/null ; then
  format=$(cat <<FORMAT_STRING
Format:     %m
Size:       %b
Width:      %w px
Height:     %h px
Colorspace: %[colorspace]
Hash:       %#\n
FORMAT_STRING)
  identify -format "$format" $1
else
  md5 < $1
fi
