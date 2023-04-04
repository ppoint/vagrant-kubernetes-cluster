#!/bin/bash -ex

JOIN_COMMAND=/vagrant_data/join_command.sh
MAX_TRIES=10
SUCCESS=0

get_join_command ()
{
  for i in `seq 1 $MAX_TRIES`
  do
    echo "Attempting to join to Kubernetes control-plane..."
    if [ -f $JOIN_COMMAND ]
    then
      sudo $JOIN_COMMAND
      SUCCESS=1
      break
    else
      echo "The $JOIN_COMMAND file hasn't been written out yet. Go to sleep "
      echo "and try again in a minute. (Attempt $i of $MAX_TRIES)"
      sleep 60
    fi
  done

  if [ $SUCCESS -eq 0 ]
  then
    echo "Was not able to join to Kubernetes master. Exiting."
    exit 1
  fi
}

get_join_command
