#Basic Script to build kernel 

#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
TC_DIR="/home/ubuntu/Kernel"
MPATH="$TC_DIR/clang/bin/:$PATH"
rm -f out/arch/arm64/boot/Image.gz-dtb
make O=out vendor/violet-perf_defconfig
PATH="$MPATH" make -j32 O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
        CROSS_COMPILE=aarch64-linux-gnu- \
        CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
        CC=clang \
        AR=llvm-ar \
        OBJDUMP=llvm-objdump \
        STRIP=llvm-strip
        2>&1 | tee error.log

cp out/arch/arm64/boot/Image.gz-dtb /home/ubuntu/Kernel/Anykernel
cd /home/ubuntu/Kernel/Anykernel 
if [ -f "Image.gz-dtb" ]; then
    zip -r9 Ryzen+-violet-"$DATE".zip * -x .git README.md *placeholder
cp /home/ubuntu/Kernel/Anykernel/Ryzen+-violet-"$DATE".zip /home/ubuntu/Kernel

#Clonning GDrive to Main DIR
wget https://www.dropbox.com/s/w65lffvkkqvvj93/gdrive?dl=1
mv gdrive?dl=1 gdrive 
chmod +x gdrive  
./gdrive list
./gdrive upload filename
./gdrive list 
./gdrive upload Ryzen+-violet-"$DATE".zip

    echo "Build success!"
else
    echo "Build failed!"
fi
