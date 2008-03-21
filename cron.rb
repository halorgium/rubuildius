#!/usr/bin/env ruby

rubuildius_dir = "~/rubuildius/"

if `ps -A | grep \`cat #{rubuildius_dir}matzbot.pid\` | wc`.to_i.zero?
  system("cd #{rubuildius_dir}; rm matzbot.pid; ./launch.rb -d -u rubuildius_xxx -n rubuildius_xxx -m rubuildius_xxx -c rubuildius_test")
end
