#!/bin/bash
counterpath="/mnt/apps/scripts/mem-check-counter.log"
logpath="/mnt/apps/scripts/mem-check-onboot-logs.log"
logmsg=$(date +"%D %T")" || "$(uptime)
echo $logmsg
echo $logmsg>> $logpath
counter=$(<$counterpath)
((counter++))
echo $counter > $counterpath
mem=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))
if [ $mem -gt 15000 ];
then
logmsg=$(date +"%D %T")" || Detected memory is $mem. It took $counter reboots to to detect this. Continuing to boot..."
echo $logmsg
echo $logmsg>> $logpath
echo "0"> $counterpath
else
if [ $counter -gt 9 ];
then
echo "0"> $counterpath
logmsg=$(date +"%D %T")" || Detected memory $mem is less than desired 15000. The script has rebooted the system $counter times to resolve this previously. The system will contine to boot with less than desired memory.";
echo $logmsg
echo $logmsg>> $logpath
exit 1
else
echo $counter> $counterpath
logmsg=$(date +"%D %T")" || Detected memory $mem is less than desired 15000. The script has rebooted the system $counter times to resolve this previously. This system will reboot again to attempt to fix..."
echo $logmsg
echo $logmsg>> $logpath
reboot
fi
fi
