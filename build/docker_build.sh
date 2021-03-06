#!/bin/bash

###############################################################################
# Simple script that uses a docker image to build the binaries of Ikemen_GO for 
# Windows/Linux/OSX plataforms
# the only dependencies are the source code of Ikemen_GO_plus and docker.
#
# @author Daniel Porto 
# https://github.com/danielporto
###############################################################################

# Parameters explained:
#  run  : download and execute the docker container with the building tools
#  --rm : discard the container after using it. It saves disk space
#  -e   : set environment variables used by the scripts called inside the container 
#         these variables select the cross-compiling parameters invoked. 
#         Look inside the get.sh and build.sh for details. 
#  -v   : maps a volume (folder) inside the  container (makes the current source code accessible inside the container)
#       $(pwd):/code is source:destination and $(pwd) maps to current directory where the script is called.
#  -i   : interactive. 
#  -t   : allocate a pseudo terminal
#  windblade/ikemen-dev:latest        : docker image configured with the tooling required to build the binaries.
#  bash -c 'cd /code && bash -x get.sh' : command called when the container launches. In changes to the code directory
#  then execute both get and build scripts 

cd ..

if [ ! -d ./bin ]; then
	mkdir bin
fi

echo "------------------------------------------------------------"
docker run --rm -e OS=linux -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x get.sh'

echo "------------------------------------------------------------"
echo "Building linux binary..."
docker run --rm -e OS=linux -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x build_crossplatform.sh' 

echo "------------------------------------------------------------"
echo "Building windows binary..."
docker run --rm -e OS=windows -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build  && bash -x build_crossplatform.sh' 

echo "------------------------------------------------------------"
echo "Building mac binary..."
docker run --rm -e OS=mac -v $(pwd):/code -it windblade/ikemen-dev:latest bash -c 'cd /code/build && bash -x build_crossplatform.sh' 