#!/bin/bash

CONTAINERNAME=vdr
IMAGENAME=vdr:debian
LOCALVIDEODIR=/mnt/data/video

# build the image

docker build -t $IMAGENAME .

# create the container

docker create\
  --name $CONTAINERNAME -t -v $LOCALVIDEODIR:/video \
  --device /dev/dvb \
  -p 8008:8008 -p 37890:37890 -p 6419:6419 -p 3000:3000 -p 34890:34890 -p 2270:2270\
  $IMAGENAME 

# start the container

docker start $CONTAINERNAME

