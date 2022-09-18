#!/bin/bash

# opencv android : https://opencv.org/opencv-4-6-0/

set -ex
NDK_HOME=/home/mirmik/Android/Sdk/ndk/22.1.7171670
OVR_HOME=/home/mirmik/soft/ovr_sdk_mobile_1.44.0
#JAVAPATH=/home/mirmik/soft/android-studio/jre/bin/javac
JAVAPATH=/usr/lib/jvm/java-8-openjdk-amd64/bin/javac
ANDROID_HOME=/home/mirmik/Android/Sdk
OPENCVANDROID=/home/mirmik/soft/OpenCV-android-sdk/

#DEXPATH=$ANDROID_HOME/build-tools/28.0.3
DEXPATH=$ANDROID_HOME/build-tools/30.0.2
COMPILERPATH=$NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin
OPENCV_INCLUDE_PATH=$OPENCVANDROID/sdk/native/jni/

LIBSFLAGS=" \
    -L $NDK_HOME/platforms/android-26/arch-arm64/usr/lib\
    -L $OVR_HOME/VrApi/Libs/Android/arm64-v8a/Debug\
    -L $OPENCVANDROID/sdk/native/staticlibs/arm64-v8a/ \
    -L $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a \
    -landroid\
    -llog\
    -lvrapi\
    -lGLESv3\
    -lopencv_core \
    -lopencv_imgcodecs \
    -lopencv_imgproc \
    -lEGL\
    -llibtiff \
    -llibopenjp2 \
    -littnotify \
    -ltbb \
    -llibjpeg-turbo \
    -ltegra_hal \
    -lIlmImf \
    -llibwebp \
    -lz \
    -llibpng"

rm -rf build
mkdir -p build
pushd build > /dev/null
$JAVAPATH\
	-classpath $ANDROID_HOME/platforms/android-26/android.jar\
	-d .\
	../src/main/java/com/makepad/hello_quest/*.java
$DEXPATH/dx --dex --output classes.dex .
mkdir -p lib/arm64-v8a
pushd lib/arm64-v8a > /dev/null


$COMPILERPATH/aarch64-linux-android26-clang\
    -march=armv8-a\
    -fPIC\
    -std=c++17 \
    -shared \
    -I ~/project/rabbit\
    -I ~/project/nos\
    -I ~/project/igris\
    -I ~/project/ralgo\
    -I ~/project/crow\
    -I $NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/\
    -I $OVR_HOME/VrApi/Include\
    -I $OPENCV_INCLUDE_PATH/modules/imgcodecs/include/ \
    -I $OPENCV_INCLUDE_PATH/modules/core/include/ \
    -I $OPENCV_INCLUDE_PATH/include/ \
    $LIBSFLAGS \
    -o libmain_cxx.so \
    -DWITH_OPENEXR=OFF -DBUILD_OPENEXR=OFF \
   ../../../src/main/cpp/*.cpp  \
   ~/project/rabbit/rabbit/opengl/drawer.cpp \
   ~/project/rabbit/rabbit/opengl/opengl_shader_program.cpp \
   ~/project/rabbit/rabbit/opengl/shader_collection.cpp \
   ~/project/rabbit/rabbit/font/naive.cpp \
   ~/project/crow/crow/pubsub/pubsub.cpp \
   ~/project/crow/crow/src/tower.cpp \
   ~/project/crow/crow/src/threads-posix.cpp \
   ~/project/crow/crow/src/gateway.cpp \
   ~/project/crow/crow/src/address.cpp \
   ~/project/crow/crow/src/hexer.cpp \
   ~/project/crow/crow/src/packet.cpp \
   ~/project/crow/crow/src/packet_ptr.cpp \
   ~/project/crow/crow/gates/udpgate.cpp \
   ~/project/crow/crow/proto/node.cpp \
   ~/project/crow/crow/proto/node-sync.cpp \
   ~/project/crow/crow/src/hostaddr.cpp \
   ~/project/crow/crow/src/hostaddr_view.cpp \
   ~/project/igris/igris/sync/syslock_mutex.cpp \
   ~/project/igris/igris/osutil/src/posix.cpp \
   ~/project/igris/igris/util/string.cpp \
   ~/project/igris/igris/osinter/wait.cpp \
   ~/project/igris/igris/osinter/wait-linux.cpp \
   ~/project/igris/igris/string/replace.cpp \


$COMPILERPATH/aarch64-linux-android26-clang\
    -march=armv8-a\
    -fPIC\
    -std=c11 \
    -shared\
    -I ~/project/rabbit\
    -I ~/project/nos\
    -I ~/project/igris\
    -I ~/project/ralgo\
    -I ~/project/crow\
    -I $NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/\
    -I $OVR_HOME/VrApi/Include\
    -I $OPENCV_INCLUDE_PATH/modules/imgcodecs/include/ \
    -I $OPENCV_INCLUDE_PATH/modules/core/include/ \
    -I $OPENCV_INCLUDE_PATH/include/ \
    $LIBSFLAGS \
    -o libmain_cc.so \
    -DWITH_OPENEXR=OFF -DBUILD_OPENEXR=OFF \
   ../../../src/main/cpp/*.c   \
   ~/project/igris/igris/osutil/realtime.c \
   ~/project/igris/igris/dprint/dprint_func_impl.c \
   ~/project/igris/igris/dprint/dprint_stdout.c \
   ~/project/igris/igris/string/replace_substrings.c \
   ~/project/igris/igris/string/memmem.c \
    /home/mirmik/Android/Sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/arm-linux-androideabi/26/libc++.a \


#$COMPILERPATH/aarch64-linux-android26-clang\
#    -march=armv8-a\
#    -fPIC\
#    -static \
#    -I ~/project/rabbit\
#    -I ~/project/nos\
#    -I ~/project/igris\
#    -I ~/project/ralgo\
#    -I ~/project/crow\
#    -I $NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/\
#    -I $OVR_HOME/VrApi/Include\
#    -I $OPENCVPATH/modules/imgcodecs/include/ \
#    -I $OPENCVPATH/modules/core/include/ \
#    -I $OPENCVPATH/include/ \
#    -o libmain.so \
#    -Wl,--start-group \
#    -DWITH_OPENEXR=OFF -DBUILD_OPENEXR=OFF \
#    libmain.cc.o \
#    libmain.cxx.o \
#    /home/mirmik/Android/Sdk/ndk/22.1.7171670/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/arm-linux-androideabi/26/libc++.a \
#    -Wl,--end-group 

cp $OVR_HOME/VrApi/Libs/Android/arm64-v8a/Debug/libvrapi.so .
popd > /dev/null
aapt\
	package\
	-F hello_quest.apk\
	-I $ANDROID_HOME/platforms/android-26/android.jar\
	-M ../src/main/AndroidManifest.xml\
	-f
aapt add hello_quest.apk classes.dex
aapt add hello_quest.apk lib/arm64-v8a/libmain_cc.so
aapt add hello_quest.apk lib/arm64-v8a/libmain_cxx.so
aapt add hello_quest.apk lib/arm64-v8a/libvrapi.so
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/staticlibs/arm64-v8a/libopencv_core.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/staticlibs/arm64-v8a/libopencv_imgcodecs.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/staticlibs/arm64-v8a/libopencv_imgproc.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/liblibopenjp2.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/libittnotify.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/libtbb.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/liblibjpeg-turbo.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/libtegra_hal.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/libIlmImf.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/liblibwebp.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/liblibpng.a
aapt add hello_quest.apk $OPENCVANDROID/sdk/native/3rdparty/libs/arm64-v8a/liblibtiff.a

apksigner\
	sign\
	-ks ~/.android/debug.keystore\
	--ks-key-alias androiddebugkey\
	--ks-pass pass:android\
	hello_quest.apk
popd > /dev/null
