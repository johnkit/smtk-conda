#!/bin/bash

# Side note: need to add conda-forge to the set of archives
# From root directory:
# > conda build meta.yaml -c defaults -c conda-forge  --python=2.7

start_dir=`pwd`
build_dir=${start_dir}/build

# Patch moab on linux
if [ "$(uname -s)" = "Linux" ]; then
  echo Patching MOAB
  cd ${SRC_DIR}/moab
  git apply ${RECIPE_DIR}/moab-src-io-mhdf-CMakeLists.txt.linux.patch
fi

# Build MOAB
mkdir -p ${build_dir}/moab
cd ${build_dir}/moab
cmake \
  -C "${RECIPE_DIR}/moab.cmake" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_TOOLCHAIN_FILE=$SRC_DIR/smtk/CMake/CondaToolchain.cmake \
  "${SRC_DIR}/moab"
cmake --build . -j "${CPU_COUNT}" --target MOAB
cmake --build . --target install

# Build SMTK
mkdir -p ${build_dir}/smtk
cd ${build_dir}/smtk
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DSMTK_ENABLE_TESTING=OFF \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  "${SRC_DIR}/smtk"
cmake --build . -j "${CPU_COUNT}"
cmake --build . --target install
