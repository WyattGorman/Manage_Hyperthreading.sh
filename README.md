# Manage_Hyperthreading.sh

Manage_Hyperthreading.sh is a simple script to manage the Intel Hyper-Thread technology on some Intel CPUs.

This script parses both information in /sys/devices/system/cpu and lscpu to determine which cores are hyperthreaded, and to online or offline them.

This script works with Google Compute Engine, and should work with most other cloud providers and other Intel Hyper-Thread enabled systems.

You must run this script as root, and the script will not run if not run as root or under sudo.

Usage
=====
./manage_hyperthreading.sh [OPTIONS]
	OPTIONS
	-d | --disable		Disable Hyper-Threaded vCPUs
	-e | --enable		Enable Hyper-Threaded vCPUs
	-h | --help		Display this usage output
