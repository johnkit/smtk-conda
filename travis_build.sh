#!/bin/bash

# Copied from
# https://gist.github.com/zshaheen/fe76d1507839ed6fbfbccef6b9c13ed9

PKG_NAME=smtk-master
USER=johnkit

OS=$TRAVIS_OS_NAME-64
mkdir ~/conda-bld
export CONDA_BLD_PATH=~/conda-bld
export DATECODE=`date +%y%m%d`

conda config --set anaconda_upload no
conda build --python=3.7 -c defaults -c conda-forge  meta.yaml
ls -l $CONDA_BLD_PATH/$OS

conda install anaconda-client
anaconda -t $CONDA_UPLOAD_TOKEN upload -u $USER -l nightly $CONDA_BLD_PATH/$OS/${PKG_NAME}${DATECODE}*.tar.bz2 --force
