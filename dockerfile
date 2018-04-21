FROM ubuntu:14.04
LABEL Description="Install Moses SMT" Version="1.0"

RUN apt-get update && apt-get install -y \
   automake \
   build-essential \
   curl \
   g++ \
   git \
   graphviz \
   imagemagick \
   libboost-all-dev \
   libbz2-dev \
   libgoogle-perftools-dev \
   liblzma-dev \
   libtool \
   make \
   python-dev \
   python-pip \
   python-yaml \
   subversion \
   unzip \
   wget \
   zlib1g-dev 

RUN pip install \
   flask \
   flask-api

RUN mkdir -p /home/moses
WORKDIR /home/moses
RUN git clone https://github.com/moses-smt/mosesdecoder
RUN mkdir moses-models

#  giza-pp-master
RUN wget -O giza-pp.zip "http://github.com/moses-smt/giza-pp/archive/master.zip" 
RUN unzip giza-pp.zip
RUN rm giza-pp.zip
RUN mv giza-pp-master giza-pp
WORKDIR /home/moses/giza-pp
RUN make
WORKDIR /home/moses
RUN mkdir external-bin-dir
RUN cp giza-pp/GIZA++-v2/GIZA++ external-bin-dir
RUN cp giza-pp/GIZA++-v2/snt2cooc.out external-bin-dir
RUN cp giza-pp/mkcls-v2/mkcls external-bin-dir

#  CMPH
RUN wget -O cmph-2.0.tar.gz "http://downloads.sourceforge.net/project/cmph/cmph/cmph-2.0.tar.gz?r=&ts=1426574097&use_mirror=cznic"
RUN tar zxvf cmph-2.0.tar.gz
WORKDIR /home/moses/cmph-2.0
RUN ./configure
RUN make
RUN make install

WORKDIR /home/moses/mosesdecoder
#  COMPILE MOSES (Takes awhile...)
# /usr/bin/bjam -j16 --max-kenlm-order=9 --with-cmph=/path/to/cmph
# 
# RUN ./bjam  -j16 --max-kenlm-order=9 --with-cmph=/home/moses/cmph-2.0 
# RUN ./bjam --with-boost=/home/moses/Downloads/boost_1_60_0 --with-cmph=/home/moses/cmph-2.0 --with-irstlm=/home/moses/irstlm -j12
#WORKDIR /home/moses/