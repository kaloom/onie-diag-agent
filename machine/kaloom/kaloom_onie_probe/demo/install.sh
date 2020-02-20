#!/bin/sh

# -------------------------------------------------------------
# Copyright © 2020 Kaloom Inc
#
# This unpublished material is property of Kaloom Inc.
# All rights reserved.
# Reproduction or distribution, in whole or in part, is
# forbidden except by express written permission of Kaloom Inc.
# -------------------------------------------------------------

# -------------------------------------------------------------
# This script collects information from the ONIE environement
# and then starts the ONIE Probe image in memmory.
# -------------------------------------------------------------

cd $(dirname $0)
base_url="${onie_exec_url%/*}"

# The save area
onie_dir="/mnt/onie-boot"

# Store base_url onto ONIE-BOOT partition for kickstart to lookup
echo ${base_url} > ${onie_dir}/base_url

# Persist the ONIE system information
# This is used by the metadata-packer to figure out manufacturer, model, MAC addresses, etc
onie_sysinfo=${onie_dir}/onie-sysinfo
onie_syseeprom=${onie_dir}/onie-syseeprom

onie-sysinfo -a > ${onie_sysinfo}
onie-syseeprom  > ${onie_syseeprom}

# The console speeds we know of
accton_ts_speed=57600
inventec_ts_speed=115200

# Set some defaults
ts_speed=115200
intf=${onie_disco_interface}

# Accton tweaks
is_accton=$(grep 'accton' ${onie_sysinfo})
if [[ ! -z "${is_accton}" ]]; then
   ts_speed=${accton_ts_speed}
   intf='enp2s0'
fi

# Inventec tweaks
is_inventec=$(grep 'inventec' ${onie_sysinfo})
if [[ ! -z "${is_inventec}" ]]; then
   ts_speed=${inventec_ts_speed}
   intf='p2p1'
fi

# Set the management interface arguments
read mgmt_mac_addr < /sys/class/net/${onie_disco_interface}/address
mgmt_args="ifname=${intf}:${mgmt_mac_addr} ip=${intf}:dhcp"

# Format the kernel arguments
kernel_args="transparent_hugepage=never --- console=ttyS0,${ts_speed} ${mgmt_args} nousb"
echo ${kernel_args} > ${onie_dir}/kernel_args

# Reboot
kexec --load --initrd=demo.initrd --append="inst.waitfornet=600 inst.repo=${base_url} ${kernel_args}" demo.vmlinuz
kexec --exec
