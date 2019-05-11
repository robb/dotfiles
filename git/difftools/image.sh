#!/bin/sh

if which sips > /dev/null ; then
  sips -g all $1 | tail -n +2 | sort
else
  md5 -r $1
fi
