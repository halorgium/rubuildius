#!/bin/sh

USER=rubuildius_xxx
NICK=rubuildius_xxx
NAME=rubuildius_xxx
CHANNEL=rubuildius_test

while true;
do
    ./launch.rb -u $USER -n $NICK -m $NAME -c $CHANNEL
    sleep 30
done
