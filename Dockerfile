ARG BASE_IMAGE

FROM ${BASE_IMAGE}

WORKDIR /tmp

RUN apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y build-essential cpanminus git && \
  apt-get install -y default-libmysqlclient-dev default-mysql-client && \
  apt-get install -y libdb-dev libgd-dev libssl-dev sqlite3 uuid-dev && \
  apt-get clean && \
  kent_version='378_branch.1' && \
  wget -nv "https://github.com/ucscGenomeBrowser/kent/archive/v${kent_version}.tar.gz" && \
  tar -xzf "v${kent_version}.tar.gz" && \
  cd "kent-${kent_version}"/src && \
  CFLAGS=-fPIC make -C lib && \
  export KENT_SRC=$PWD && \
  export MACHTYPE=`uname -m` && \
  cd ../.. && \
  cpanm --notest Bio::DB::BigFile && \
  rm -rf "kent-${kent_version}"
