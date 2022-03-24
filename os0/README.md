# os0
实现一个最简陋的操作系统

# 原理
```
把asm编译成目标文件.o
再把目标文件连接成kernel.bin
kernel.bin是一个elf文件
muiltiboot2引导的时候从elf的入口点开始执行
```

## 安装依赖
```
yum install -y nasm
yum install -y glibc-devel.i686
yum install -y glibc-static libstdc++-static
yum install -y glibc-static.i686 libgcc.i686
yum install -y xorriso
yum install -y qemu-system-x86
yum install -y seabios
make iso
qemu-system-i386 -cdrom build/kernel-x86.iso -vga std -d int,cpu_reset -no-reboot
qemu-system-i386 -d int,cpu_reset -no-reboot -cdrom build/kernel-x86.iso -boot order=dc
```

## 编译iso
make iso

## 运行
make run, 输出hello world!

参考项目:  
https://github.com/SanseroGames/LetsGo-OS