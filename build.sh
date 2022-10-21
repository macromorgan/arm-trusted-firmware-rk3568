#!/bin/bash
make ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- PLAT=rk3568 clean
make LOAD_IMAGE_V2=1 ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- PLAT=rk3568 bl31 all
