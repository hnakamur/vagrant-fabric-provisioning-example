#!/bin/bash

PREFIX=/usr/local
GMP_VER=5.1.2
PYTHON_VER=2.7.5
PYCRYPTO_VER=2.6

# install gmp
# pycrypto 2.6 needs gmp >= 5.0, however gmp rpm version is 4.3.1.
# So we need to install gmp from source.
install_gmp() {
  if [ ! -f /etc/ld.so.conf.d/libgmp.so.10.conf ]; then
    yum install -y curl tar xz gcc make m4
    curl ftp://ftp.gnu.org/gnu/gmp/gmp-$GMP_VER.tar.xz -o $PREFIX/src/gmp-$GMP_VER.tar.xz
    tar xf $PREFIX/src/gmp-$GMP_VER.tar.xz -C $PREFIX/src
    cd $PREFIX/src/gmp-$GMP_VER
    ./configure
    make
    make install
    echo $PREFIX/lib > /etc/ld.so.conf.d/libgmp.so.10.conf
    ldconfig
  fi
}

install_python() {
  if [ ! -f $PREFIX/python-$PYTHON_VER/bin/python ]; then
    yum install -y \
      git \
      gcc \
      tar \
      make \
      bzip2-devel \
      readline-devel \
      openssl-devel \
      sqlite-devel
    cd $PREFIX/src
    git clone git://github.com/tagomoris/xbuild.git
    $PREFIX/src/xbuild/python-install $PYTHON_VER $PREFIX/python-$PYTHON_VER
  fi

  if ! grep -q "export PATH=$PREFIX/python-$PYTHON_VER/bin:\$PATH" \
      ~/.bash_profile; then
    echo "export PATH=$PREFIX/python-$PYTHON_VER/bin:\$PATH" >> ~/.bash_profile
  fi
}

install_pycrypto() {
  if [ ! -f $PREFIX/src/pycrypto-$PYCRYPTO_VER.tar.gz ]; then
    curl https://pypi.python.org/packages/source/p/pycrypto/pycrypto-$PYCRYPTO_VER.tar.gz -o $PREFIX/src/pycrypto-$PYCRYPTO_VER.tar.gz
  fi
  if [ ! -d $PREFIX/src/pycrypto-$PYCRYPTO_VER ]; then
    tar xf $PREFIX/src/pycrypto-$PYCRYPTO_VER.tar.gz -C $PREFIX/src
  fi
  if [ -z "`pip show pycrypto`" ]; then
    cd $PREFIX/src/pycrypto-$PYCRYPTO_VER
    python setup.py install --prefix=$PREFIX/python-$PYTHON_VER
  fi
}

install_fabric() {
  if [ -z "`pip show fabric`" ]; then
    pip install fabric
  fi
  if [ -z "`pip show fabtools`" ]; then
    pip install fabtools
  fi
}


install_gmp
install_python
export PATH=$PREFIX/python-$PYTHON_VER/bin:$PATH
install_pycrypto
install_fabric
