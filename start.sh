#!/bin/bash

set -e

KURA_PATH=/opt/eclipse/kura
KURA_LOG=/var/log/kura.log
NOHUP_OUT=/var/log/nohup.out

GLUSTER_MOUNT=/mnt/kura

if [ -d $GLUSTER_MOUNT ]; then
	echo "Using gluster on $GLUSTER_MOUNT ..."
	for dir in data user; do
		if [ ! -d $GLUSTER_MOUNT/$dir ]; then
			echo "Initial copy of $GLUSTER_MOUNT/$dir to $GLUSTER_MOUNT/$dir ..."
			cp -ar $KURA_PATH/$dir $GLUSTER_MOUNT
		fi
		mv $KURA_PATH/$dir $KURA_PATH/$dir.bak
		ln -s $GLUSTER_MOUNT/$dir $KURA_PATH/$dir
	done
	echo "Set up of gluster on $GLUSTER_MOUNT done"
fi

echo "Enable the detection of container-limited amount of RAM ..."
LIMIT_RAM=' -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap'
sed -Ei "s# -Xms512m -Xmx512m#\0${LIMIT_RAM}#g" $KURA_PATH/bin/start_kura.sh

nohup $KURA_PATH/bin/start_kura.sh $KURA_LOG >> $NOHUP_OUT &
KURA_PID=$!

while [ ! -e $KURA_LOG ]; do
	echo "Waiting for kura to write to $KURA_LOG ..."
	sleep 1
done

echo "Print kura start output ..."
cat $NOHUP_OUT

echo "Tail kura log ..."
tail -f $KURA_LOG &

wait $KURA_PID
