#!/bin/bash
HOST="ups.unbound.am:7433"
echo "Starting monitoring host $HOST for commands"
while [ True ] ;do
    result=$(curl -s $HOST)
    if [ "$result" == "shutdown" ];then
        echo "Initiating shutdown"
        python /home/serg/src/useful-stuff/ups/vm-shutdown.py
        shutdown now;
    elif [ "$result" != "normal" ];then
        echo "$result"
    fi
    sleep 5;
done
