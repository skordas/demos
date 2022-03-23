 #!/bin/bash

# Get the file - copy and paste in terminal to get demo file:
# wget https://raw.githubusercontent.com/skordas/demos/master/ci-watcher-scheduler/ci-watcher-scheduler.sh

# Run the demo:
# bash ci-watcher-scheduler.sh

# Colors
red="\e[31m"
blue="\e[34m"
brown="\e[33m"
reset="\e[0m"

function printl() {
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
	read
}

function printn() {
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
}

function indent_printl() {
	echo -e "\t" | tr -d '\n'
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
	read
}

function indent_printn() {
	echo -e "\t" | tr -d '\n'
	for i in $1
	do
		echo -e "$brown$i " | tr -d '\n'
		sleep 0.15
	done
	echo -e "$reset"
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

# DEMO:

clear
printn "############################"
printn "### CI Watcher Scheduler ###"
printl "############################"
printn "Content:"
indent_printl "- How it's working now?"
indent_printl "- CI-Watcher-Scheduler"
indent_printl "- DEMO!"
indent_printl "- ToDo's - Problems and things to discuss"

clear
printn "#############################"
printn "### How it's working now? ###"
printl "#############################"
printn "Automation Test Result Tracker"
printl "https://docs.google.com/spreadsheets/d/1iv-baHyfPua0104VnSGRnbpnDmGWzjN_hVNiq_n-_ag/edit#gid=927572443"
printn "Holidays. Ex. US"
printn "https://calendar.google.com/calendar/embed?src=company%40redhat.com&ctz=America%2FNew_York"
printl "https://rover.redhat.com/people/profile/skordas"
printn "PTOs"
printl "https://calendar.google.com/calendar/embed?src=redhat.com_tigabftngp6f1tvgqn17l1c25g%40group.calendar.google.com&ctz=America%2FNew_York"
printn "OpenShift QE Release Lead and Manager Schedule"
printl "https://docs.google.com/spreadsheets/d/19pDll3fOQLg3Fj7UsZ_d8PZ2IeDzq7ZuaE1ARITgcMs/edit#gid=1850747812"


clear
printn "############################"
printn "### CI-Watcher-Scheduler ###"
printl "############################"
printn "NEW Automation Test Result Tracker"
printl "https://docs.google.com/spreadsheets/d/1Za68tWwVMVAqetr7GcvCddVEdkNhEP1jOyrbARnIJAk/edit#gid=0"
printn "CI Watcher Scheduler"
printl "https://github.com/skordas/ci-watcher-scheduler"

clear
printn "#####################################################"
printn "####### DEMO! - short - how it supposed to be #######"
printn "### It's about automation - it should be short :) ###"
printl "#####################################################"

clear
printn "###############################################"
printn "### ToDo's - Problems and things to discuss ###"
printl "###############################################"
indent_printl "QA in QE and QE in QA:"
indent_printl "\t- All TODOs in code"
indent_printl "\t- Unit tests"
indent_printl "Missing functionality:"
indent_printl "\t- Support for ~New To CI~"
indent_printl "\t- Full calendar integration"
indent_printl "\t- PTO calendar checks"
indent_printl "\t- Data validation"
indent_printl "\t- Release lead integration"
indent_printl "Management"
indent_printl "\t- Manager rotation?"
indent_printl "\t- Who? When? How?"
indent_printl "\t- Jenkins integration?"
