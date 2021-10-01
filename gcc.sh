#!/usr/bin/env bash
echo "Cloning dependencies"
git clone https://github.com/mvaisakh/gcc-arm64 --depth=1
git clone https://github.com/mvaisakh/gcc-arm --depth=1
git clone --depth=1 https://gitlab.com/Baibhab34/AnyKernel3.git -b rmx1801 AnyKernel
echo "Done"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
export CONFIG_PATH=$PWD/arch/arm64/configs/RMX1801_defconfig
PATH="$(pwd)/gcc-arm64/bin:$(pwd)/gcc-arm/bin:${PATH}" \
export ARCH=arm64
export USE_CCACHE=1
export KBUILD_BUILD_HOST=GCC
export KBUILD_BUILD_USER="baibhab"

# Compile plox
function compile() {
   make O=out ARCH=arm64 RMX1801_defconfig
     PATH="$(pwd)/gcc-arm64/bin:$(pwd)/gcc-arm/bin:${PATH}" \
       make -j$(nproc --all) O=out \
                             ARCH=arm64 \
                             CROSS_COMPILE=aarch64-elf- \
                             CROSS_COMPILE_ARM32=arm-eabi-
   cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}
# Zipping
function zipping() {
    cd AnyKernel || exit 1
   zip -r9 Avalanche-RMX1801-EAS-${TANGGAL}.zip *
    curl https://bashupload.com/Avalanche-RMX1801-EAS-${TANGGAL}.zip --data-binary @Avalanche-RMX1801-EAS-${TANGGAL}.zip
    cd ..
}
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
