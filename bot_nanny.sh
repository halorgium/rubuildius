#!/bin/sh

IRC_USER=rubuildius_xxx
IRC_NICK=rubuildius_xxx
IRC_NAME=rubuildius_xxx
IRC_CHANNEL=rubuildius_test

cd $HOME/rubuildius/

bot_status=`ps -A | grep \`cat matzbot.pid\` | wc -l`

if [ $bot_status = '0' ]; then
    rm matzbot.pid
    exec ruby launch.rb -u $IRC_USER -n $IRC_NICK -m $IRC_NAME -c $IRC_CHANNEL
fi
