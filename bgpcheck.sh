#!/bin/env bash
#Test if prefix exists in frankfurt exchange.
prefix=$1

res=$(curl -s "https://lg.de-cix.net/api/v1/lookup/prefix?q=$prefix")
res=$(echo $res | jq '.imported.routes[0].neighbor.asn')
if [ -z "$res" ];then
    echo $res
    exit 0
else
    echo ""
    exit 1
fi
