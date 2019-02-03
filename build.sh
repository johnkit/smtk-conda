#!/bin/bash

# Side note: need to add conda-forge to the set of archives
# From root directory:
# > conda build meta.yaml -c defaults -c conda-forge  --python=2.7
#
# Building on OS X does not work with current SDK (10.14).
# Recommended build requires 10.9 SDK.
# To build on OS X using python 3.6:
# > export CONDA_BUILD_SYSROOT=$(xcode-select --print-path)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk
# > build meta.yaml -c defaults -c conda-forge --python=3.6

start_dir=`pwd`
build_dir=${start_dir}/build

# Patch moab on linux
echo Patching MOAB
cd ${SRC_DIR}/moab
git apply ${RECIPE_DIR}/moab-CMakeLists.txt.patch
git apply ${RECIPE_DIR}/moab-src-io-mhdf-CMakeLists.txt.patch

# Build MOAB
mkdir -p ${build_dir}/moab
cd ${build_dir}/moab
cmake \
  -C "${RECIPE_DIR}/moab.cmake" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_TOOLCHAIN_FILE=$SRC_DIR/smtk/CMake/CondaToolchain.cmake \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
  -DCMAKE_OSX_SYSROOT=$CONDA_BUILD_SYSROOT \
  "${SRC_DIR}/moab"
cmake --build . -j "${CPU_COUNT}" --target install

# Build SMTK
mkdir -p ${build_dir}/smtk
cd ${build_dir}/smtk
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DSMTK_ENABLE_EXODUS_SESSION=OFF \
  -DSMTK_ENABLE_OSCILLATOR_SESSION=OFF \
  -DSMTK_ENABLE_RGG_SESSION=OFF \
  -DSMTK_ENABLE_TESTING=OFF \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DBOOST_INCLUDEDIR=$PREFIX/include \
  -DBOOST_LIBRARYDIR=$PREFIX/lib \
  -DBoost_NO_SYSTEM_PATHS=ON \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
  -DCMAKE_OSX_SYSROOT=$CONDA_BUILD_SYSROOT \
  -DPYTHON_EXECUTABLE=$PYTHON \
  "${SRC_DIR}/smtk"
cmake --build . -j "${CPU_COUNT}" --target install
