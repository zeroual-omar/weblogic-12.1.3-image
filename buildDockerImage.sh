#!/bin/bash
#
# $1 : image name 

docker build  --no-cache=true -t $1 .

