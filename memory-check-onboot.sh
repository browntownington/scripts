#!/bin/bash
minmem=15000
counterpath="/mnt/apps/scripts/memory-check-onboot-counter.log"
logpath="/mnt/apps/scripts/memory-check-onboot.log"
logmsg=$(date +"%D %T")" || "$(uptime)
echo $logmsg
echo $logmsg>> $logpath
counter=$(<$counterpath)
((counter++))
echo $counter > $counterpath
mem=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))
if [ $mem -gt $minmem ];
then
logmsg=$(date +"%D %T")" || Detected memory is $mem. It took $counter reboots to to detect this. Continuing to boot..."
echo $logmsg
echo $logmsg>> $logpath
echo "0"> $counterpath
else
if [ $counter -gt 9 ];
then
echo "0"> $counterpath
logmsg=$(date +"%D %T")" || Detected memory $mem is less than desired 15000. The script has rebooted the system $counter times to resolve this >
echo $logmsg
echo $logmsg>> $logpath
exit 1
else
echo $counter> $counterpath
logmsg=$(date +"%D %T")" || Detected memory $mem is less than desired 15000. The script has rebooted the system $counter times to resolve this >
echo $logmsg
echo $logmsg>> $logpath
reboot
fi
fi

