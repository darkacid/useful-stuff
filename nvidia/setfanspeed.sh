#!/usr/bin/env bash

export DISPLAY=:0
speed=40
if [[ ! -z $1 ]];then
    speed=$1
fi 

nvidia-settings -a [gpu:0]/GPUFanControlState=1
nvidia-settings -a [fan:0]/GPUTargetFanSpeed=$speed
