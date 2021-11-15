#!/bin/bash
i=0
while [ True ] ;do
    result=$(xrandr --verbose | grep -i 960x540)
    if [ ! -z "$result" ];then
        #Secondary monitor off - power loss
        echo "$i"
        i=$((i+1))
        if [ $i -ge 30 ];then
            #Suspend after 15 minutes
            i=0
            systemctl suspend;
        fi
    else
        i=0
    fi

    sleep 10
done
