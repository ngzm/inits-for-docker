#!/bin/bash
#
# init_node.sh
# - init process for aplications using node.js.
# 
# Usage
# - add your Dockerfile as follows.
#   ------------
#   ADD ./init_node.sh /usr/local/bin
#   RUN chmod +x /usr/local/bin/init_node.sh
#   CMD ["init_node.sh", [path_to_your_app]]
#   ------------
#

echo "start init_node.sh"

# set application path
path_to_your_app=${1:-''}
if [ -z ${path_to_your_app} ]; then
  echo "require first argment for path_to_your_app"
  echo "quit this container"
  exit 1
fi

if [ ! -e ${path_to_your_app} ]; then
  echo "${path_to_your_app} is not exists"
  echo "quit this container"
  exit 2
fi

# Application PID initialize
your_app_pid=0

# SIGINT handler
int_handler() {
  echo "int_handler called"
  if [ ${your_app_pid} -ne 0 ]; then
    kill -INT ${your_app_pid}
  fi
}

# SIGTERM handler
term_handler() {
  echo "term_handler called"
  if [ ${your_app_pid} -ne 0 ]; then
    kill -TERM ${your_app_pid}
  fi
}

# trap SIGINT - usually caught by Ctrl+c
trap 'int_handler' INT

# trap SIGTERM - sent when 'docker stop'
trap 'term_handler' TERM

# run application
echo "run ${path_to_your_app}"

node ${path_to_your_app} &
your_app_pid="${!}"

# wait untill the application (child process) will be killed
wait ${your_app_pid}
your_app_pid=0

echo "finish init_node.sh"
