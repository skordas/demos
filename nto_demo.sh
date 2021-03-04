#!/bin/bash

# Colors
red="\e[31m"
blue="\e[34m"
brown="\e[33m"
reset="\e[0m"

function line() {
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
	read
}

function indent_line() {
	echo -e "\t" | tr -d '\n'
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
	read
}

function display_and_run() {
	echo -e "$red$ $blue" | tr -d '\n'
	for i in $1
	do
		echo -e "$i " | tr -d '\n'
		sleep 0.15
	done
	printf "$reset"
	read -r
	eval $1
	read
}

#test

clear
line "Node Tuning Operator"
clear
line "Content:"
indent_line "- Tuned"
indent_line "- Tuned Node"
indent_line "- Node Tuning Operator"
indent_line "- Examples"
indent_line "- Bonus: NTO as SLO"

clear
line "TUNED"
line "Installation"
indent_line "https://github.com/redhat-performance/tuned"
line "# RHEL"
indent_line "$ yum install tuned"
line "# Fedora"
indent_line "$ dnf install tuned"
clear
line "TUNED"
display_and_run "man tuned"
display_and_run "man tuned-adm"
display_and_run "tuned-adm active"
display_and_run "tuned-adm list"
display_and_run "ls /etc/tuned"
display_and_run "ls /usr/lib/tuned"
display_and_run "vim /usr/lib/tuned/balanced/tuned.conf"
display_and_run "vim /usr/lib/tuned/desktop/tuned.conf"
display_and_run "sysctl kernel.sched_autogroup_enabled"
display_and_run "tuned-adm profile desktop"
display_and_run "sysctl kernel.sched_autogroup_enabled"
display_and_run "tuned-adm profile balanced"
display_and_run "sysctl kernel.sched_autogroup_enabled"

clear
line "Tuned Node"
display_and_run "oc project openshift-cluster-node-tuning-operator"
display_and_run "oc get pods -o wide"