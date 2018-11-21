#!/bin/bash

# Author
# Wyatt Gorman, Google Inc
# wyattgorman@google.com

# Copyright 2018 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function main() {
	if [ "`whoami`" != "root" ]; then
		echo "You must run this script as root, or with \"sudo $0\""
		exit 1
	fi
	
	shortOpts=":deh"
	longOpts=":disable,enable,help"
	args=$(getopt -o $shortOpts -l $longOpts -- "$@")
	
	if [ $? -ne 0 ]; then
	        usage
	        exit
	fi
	
	eval set -- "$args"
	q=0
	disable=0
	enable=0
	
	while true ; do
	        case $1 in
	                -d|--disable	)       disable=1; shift;;
	                -e|--enable	)	enable=1; shift;;
	                -h|--help	)	usage; exit;;
	                --      	)       shift; break;;
	                *       	)       usage; exit;;
	        esac
	done

	if [ $disable -eq 1 ]; then
		disable
	elif [ $enable -eq 1 ]; then
		enable
	fi
}
	
function enable(){
	echo -e "Enabling Hyper-Threaded vCPUs...\nNOTE: This will enable all currently offline cores..."
	sleep 3
	
	for vcpu in `lscpu --extended | grep "no" | awk '{print $1}'`; do
		echo "Enabling core $vcpu"
		echo 1 > /sys/devices/system/cpu/cpu$vcpu/online
	done
	echo "Done."
}
	
function disable(){
	echo "Disabling Hyper-Threaded vCPUs..."
	sleep 3
	
	for vcpu in `cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | cut -s -d, -f2- | sort -u`; do
		echo "Disabling core $vcpu"
		echo 0 > /sys/devices/system/cpu/cpu$vcpu/online
	done
	echo "Done."
}

function usage(){
	echo "USAGE: $0 [OPTIONS]"
	echo "	OPTIONS"
	echo "	-d | --disable		Disable Hyper-Threaded vCPUs"
	echo "	-e | --enable		Enable Hyper-Threaded vCPUs"
	echo "	-h | --help		Display this usage output"
}

main $@
