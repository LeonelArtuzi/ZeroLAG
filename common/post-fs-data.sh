#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode

#version: 0.1
#Author: Leonel Artuzi
#e-mail:leonel.artu@gmail.com
#xda-user:@leohiper10


target=`getprop ro.board.platform`
low_ram=`getprop ro.config.low_ram`
ProductName=`getprop ro.product.name`


#in the future tunables for specific devices 
#if [ -f /sys/devices/soc0/soc_id ]; then
#   soc_id=`cat /sys/devices/soc0/soc_id`
#else
#   soc_id=`cat /sys/devices/system/soc/soc0/id`
#fi


function configure_zram_() {
    memsize=`cat /proc/meminfo | grep "MemTotal" | awk '{print $2}'`

    if [ $memsize -lt 4294967 ]
        echo lz4 > /sys/block/zram0/comp_algorithm
        echo 1024000000 > /sys/block/zram0/disksize
        mkswap /dev/block/zram0
        swapon /dev/block/zram0

}


#function cat_freq_table(){
#
#    if ["$is_octa"=="true"];then
#        table1=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`
#        table2=`cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies`    
#
#    else
#        table1=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`
#    fi
#}


#CPU
if [ -f /sys/devices/system/cpu/cpu*/cpufreq/ ]; then 

    echo 0 > /sys/module/msm_thermal/core_control/enabled
    
    # we want all cpus up all the time 
    echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/disable
    
    echo 1 > /sys/devices/system/cpu/cpu0/online
    cpu= `/sys/devices/system/cpu/cpu0/cpufreq`
    avail_govs=`cat $cpu/scaling_available_governors` 
    max_cpu_freq=`cat $cpu/cpuinfo_max_freq`    
    if [ "$avail_govs" == *"schedutil"*  ];then
        echo  schedutil > $cpu/scaling_governor
        echo 5000 > $cpu/schedutil/up_rate_limit_us
        echo 5000 > $cpu/schedutil/down_rate_limit_us
        echo 5000 > $cpu/schedutil/rate_limit_us
        echo 75 > $cpu/schedutil/hispeed_load
        echo $max_cpu_freq > $capu/cpuinfo_max_freq

    elif [ "$avail_govs" == *"interactive"* ]; then
        echo  interactive > $cpu/scaling_governor        
        echo 5000 > $cpu/interactive/min_sample_time    
        echo 75 > $cpu/interactive/go_hispeed_load
        echo $max_cpu_freq > $cpu/interactive/hispeed_freq
    fi

    echo 1 > /sys/devices/system/cpu/cpu1/online
    echo 1 > /sys/devices/system/cpu/cpu2/online
    echo 1 > /sys/devices/system/cpu/cpu3/online

    if [-f /sys/devices/system/cpu/cpu4]; then
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo 1 > /sys/devices/system/cpu/cpu5/online
        echo 1 > /sys/devices/system/cpu/cpu6/online
        echo 1 > /sys/devices/system/cpu/cpu7/online
    fi
fi    







