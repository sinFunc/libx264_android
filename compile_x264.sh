#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


ANDROID_NDK=${DIR}/android-ndk-r26d-linux/android-ndk-r26d
echo "android-ndk-path=$ANDROID_NDK"

TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
BUILD_DIR=x264_c_android
if [ -d "./$BUILD_DIR" ] ;then
  rm -r $BUILD_DIR
  echo "------------remove $BUILD_DIR"
fi

export NDK=$ANDROID_NDK
export PATH=${PATH}:$NDK

CROSS_PREFIX=$TOOLCHAIN/bin/llvm-
echo "CROSS_PREFIX=$CROSS_PREFIX"

SYSROOT=$TOOLCHAIN/sysroot
echo "SYSROOT=$SYSROOT"

EXTRA_LDCFLGS="-nostdlib"

function build_x264_r26()
{
  export CC=$TOOLCHAIN/bin/$C_COMPILE-clang
  export CXX=$TOOLCHAIN/bin/$C_COMPILE-clang++

  PREFIX=$DIR/$BUILD_DIR/$ANDROID_ABI

  cd ${DIR}/x264-stable
  echo "The compilation dir is $(pwd)"

  ./configure \
    --prefix=$PREFIX \
    --enable-static \
    --enable-shared \
    --enable-pic \
    --host=$HOST \
    --sysroot=$SYSROOT \
    --cross-prefix=$CROSS_PREFIX \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-ldflags="$EXTRA_LDCFLGS" \
    --enable-strip \
    --disable-win32thread \
    --disable-avs \
    --disable-swscale \
    --disable-cli \
    --disable-lavf \
    --disable-ffms \
    --disable-gpac \
    --disable-lsmash \
    $ASM_CONFIG

  make clean
  make -j6
  make install
  echo "The compilation of x264 $ANDROID_ABI is completed"


}

#----------armv7a-->arm-->armv7a-->amrv7a-linux-android-
ANDROID_ABI=armeabi-v7a
HOST=arm-linux-androideabi
C_COMPILE=armv7a-linux-androideabi26
EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -mthumb -D__ANDROID__ -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -D__ARM_ARCH_7R__ -D__ARM_ARCH_7M__ -D__ARM_ARCH_7S__"
ASM_CONFIG="--disable-asm"
build_x264_r26


#------------armv8a--->amr64--->aarch64-linux-android-
ANDROID_ABI=arm64-v8a
HOST=aarch64-linux-android
C_COMPILE=aarch64-linux-android26
EXTRA_CFLAGS="-march=armv8-a -D__ANDROID__ -D__ARM_ARCH_8__ -D__ARM_ARCH_8A__"
ASM_CONFIG="--enable-asm"
build_x264_r26

function build_x264_x86()
{
  cd ${DIR}/x264-stable
  echo "The compilation dir is $(pwd)"

  PREFIX=$DIR/$BUILD_DIR/x86_64
  --extra-cflags="$EXTRA_CFLAGS" \

  ./configure \
    --prefix=$PREFIX \
    --enable-static \
    --enable-shared \
    --enable-pic \
    --enable-asm \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-ldflags="$EXTRA_LDCFLGS" \
    --enable-strip \
    --disable-win32thread \
    --disable-avs \
    --disable-swscale \
    --disable-cli \
    --disable-lavf \
    --disable-ffms \
    --disable-gpac \
    --disable-lsmash 
    
  make clean
  make -j6
  make install
  echo "The compilation of x264 $ANDROID_ABI is completed"

}

#build_x264_x86



function build_x264_r14b()
{
  ANDROID_NDK=${DIR}/android-ndk-r14b-linux-x86_64/android-ndk-r14b
  echo "android-ndk-path=$ANDROID_NDK"

  export NDK=$ANDROID_NDK
  export PATH=${PATH}:$NDK

#  ndk-build
#  exit

  #armeabi-v7a
#  ANDROID_ABI=amreabi-v7a
#  ANDROID_API=android-14
#  ANDROID_ARCH=arch-arm
#  ANDROID_EABI=arm-linux-androideabi-4.9
#  HOST=arm-linux-androideabi

  #arm64-v8a
  ANDROID_ABI=amr64-v8a
  ANDROID_API=android-21
  ANDROID_ARCH=arch-arm64
  ANDROID_EABI=aarch64-linux-android-4.9

  HOST=aarch64-linux-android


  TOOLCHAIN=$ANDROID_NDK/toolchains/$ANDROID_EABI/prebuilt/linux-x86_64/bin
  SYSROOT=$ANDROID_NDK/platforms/$ANDROID_API/ANDROID_ARCH

  CROSS_COMPILE=aarch64-linux-android
  CROSS_PREFIX=$TOOLCHAIN/$CROSS_COMPILE
  echo "CROSS_PREFIX=$CROSS_PREFIX"

  PREFIX=$DIR/x264_android/$ANDROID_ABI

  cd ${DIR}/x264-stable
  echo "The compilation dir is $(pwd)"
  ./configure \
    --prefix=$PREFIX \
    --disable-asm \
    --enable-static \
    --enable-shared \
    --enable-pic \
    --host=$HOST \
    --cross-prefix=$CROSS_PREFIX \
    --sysroot=$SYSROOT \
    --disable-cli


  make clean
  make -j6
  make install
  echo "The compilation of x264 $ANDROID_ABI is completed"

}

#build_x264_r14b













