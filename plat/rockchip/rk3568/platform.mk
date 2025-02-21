#
# Copyright (c) 2019, ARM Limited and Contributors. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

RK_PLAT			:=	plat/rockchip
RK_PLAT_SOC		:=	${RK_PLAT}/${PLAT}
RK_PLAT_COMMON		:=	${RK_PLAT}/common

DISABLE_BIN_GENERATION	:=	1
GICV3_SUPPORT_GIC600	:=	1
include lib/coreboot/coreboot.mk
include lib/libfdt/libfdt.mk
include lib/xlat_tables_v2/xlat_tables.mk
# GIC-600 configuration
GICV3_IMPL		:=	GIC600
# Include GICv3 driver files
include drivers/arm/gic/v3/gicv3.mk

PLAT_INCLUDES		:=	-Iinclude/bl31					\
				-Iinclude/common				\
				-Iinclude/drivers				\
				-Iinclude/drivers/arm				\
				-Iinclude/drivers/auth				\
				-Iinclude/drivers/io				\
				-Iinclude/drivers/ti/uart			\
				-Iinclude/lib					\
				-Iinclude/lib/cpus/${ARCH}			\
				-Iinclude/lib/el3_runtime			\
				-Iinclude/lib/pmf				\
				-Iinclude/lib/psci				\
				-Iinclude/plat/common				\
				-Iinclude/services				\
				-Iinclude/plat/common/				\
				-Idrivers/arm/gic/v3/				\
				-I${RK_PLAT_COMMON}/				\
				-I${RK_PLAT_COMMON}/pmusram/			\
				-I${RK_PLAT_COMMON}/include/			\
				-I${RK_PLAT_COMMON}/drivers/pmu/		\
				-I${RK_PLAT_COMMON}/drivers/parameter/		\
				-I${RK_PLAT_SOC}/				\
				-I${RK_PLAT_SOC}/drivers/pmu/			\
				-I${RK_PLAT_SOC}/drivers/soc/			\
				-I${RK_PLAT_SOC}/include/

RK_GIC_SOURCES		:=	${GICV3_SOURCES}				\
				plat/common/plat_gicv3.c			\
				${RK_PLAT}/common/rockchip_gicv3.c

PLAT_BL_COMMON_SOURCES	:=	${XLAT_TABLES_LIB_SRCS}				\
				common/desc_image_load.c			\
				plat/common/aarch64/crash_console_helpers.S	\
				lib/bl_aux_params/bl_aux_params.c		\
				plat/common/plat_psci_common.c

BL31_SOURCES		+=	${RK_GIC_SOURCES}				\
				drivers/arm/cci/cci.c				\
				lib/cpus/aarch64/cortex_a55.S			\
				drivers/ti/uart/aarch64/16550_console.S		\
				drivers/delay_timer/delay_timer.c		\
				drivers/delay_timer/generic_delay_timer.c	\
				$(LIBFDT_SRCS)					\
				${RK_PLAT_COMMON}/aarch64/plat_helpers.S	\
				${RK_PLAT_COMMON}/bl31_plat_setup.c		\
				${RK_PLAT_COMMON}/params_setup.c		\
				${RK_PLAT_COMMON}/plat_pm.c			\
				${RK_PLAT_COMMON}/plat_topology.c		\
				${RK_PLAT_COMMON}/rockchip_sip_svc.c		\
				${RK_PLAT_COMMON}/pmusram/cpus_on_fixed_addr.S	\
				${RK_PLAT_COMMON}/drivers/parameter/ddr_parameter.c	\
				${RK_PLAT_COMMON}/aarch64/platform_common.c	\
				${RK_PLAT_SOC}/drivers/soc/soc.c		\
				${RK_PLAT_SOC}/drivers/pmu/pmu.c

ENABLE_PLAT_COMPAT	:=	0
MULTI_CONSOLE_API	:=	1
# System coherency is managed in hardware
HW_ASSISTED_COHERENCY	:=	1

# When building for systems with hardware-assisted coherency, there's no need to
# use USE_COHERENT_MEM. Require that USE_COHERENT_MEM must be set to 0 too.
USE_COHERENT_MEM	:=	0

$(eval $(call add_define,PLAT_SKIP_OPTEE_S_EL1_INT_REGISTER))
$(eval $(call add_define,PLAT_EXTRA_LD_SCRIPT))
