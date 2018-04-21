FROM ubuntu:latest

MAINTAINER Momo <mo@mo.com>
LABEL description="Basic Moses docker container for Ubuntu"

# Update Ubuntu.
RUN apt-get update
RUN apt-get install -y apt-utils debconf-utils
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get -y upgrade

# Install some necessary tools.
RUN apt-get install -y nano perl

# Install Moses dependencies.
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y build-essential git-core pkg-config automake libtool wget zlib1g-dev python-dev libbz2-dev cmake

# Clone the repos we need.
RUN git clone https://github.com/moses-smt/mosesdecoder.git

# Install Moses.
WORKDIR /mosesdecoder
RUN make -f /mosesdecoder/contrib/Makefiles/install-dependencies.gmake

#  COMPILE MOSES (Takes awhile...)
# /usr/bin/bjam -j16 --max-kenlm-order=9 --with-cmph=/path/to/cmph
# 
# RUN ./bjam  -j16 --max-kenlm-order=9 --with-cmph=/home/moses/cmph-2.0 
# RUN ./bjam --with-boost=/home/moses/Downloads/boost_1_60_0 --with-cmph=/home/moses/cmph-2.0 --with-irstlm=/home/moses/irstlm -j12
#WORKDIR /home/moses/