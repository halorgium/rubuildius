#!/bin/sh

IRC_USER=rubuildius_xxx
IRC_NICK=rubuildius_xxx
IRC_NAME=rubuildius_xxx
IRC_CHANNEL=rubuildius_test

while true;
do
    ./launch.rb -u $IRC_USER -n $IRC_NICK -m $IRC_NAME -c $IRC_CHANNEL
    sleep 30
done
