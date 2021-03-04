#!/bin/bash

# Get the file - copy and paste in terminal to get demo file:
# wget https://raw.githubusercontent.com/skordas/demos/master/NTO/nto_demo.sh

# Run the demo:
# bash nto_demo.sh

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

function cleaning() {
	echo -e "         $red#########$blue Cleaning after demo $red#########$reset"
	oc label pod $pod tuned.openshift.io/elasticsearch-
	oc project default
	rm nf-conntrack-max.yaml performance.yaml
}

# Demo:

clear
line "Node Tuning Operator"
line "Content:"
indent_line "- Tuned"
indent_line "- Tuned Node"
indent_line "- Node Tuning Operator"
indent_line "- Examples"
indent_line "- Bonus: NTO as SLO"

clear
line "TUNED"
line "Installation:"
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
line "TUNED NODE"
display_and_run "oc project openshift-cluster-node-tuning-operator"
line "Lets store node and pod name for future use:"
display_and_run "node=\$(oc get nodes | grep -m 1 worker | cut -f 1 -d ' ') && echo \$node"
display_and_run "pod=\$(oc get pods -n openshift-cluster-node-tuning-operator -o wide | grep \$node | cut -d ' ' -f 1) && echo \$pod"
display_and_run "oc get pods -o wide"
display_and_run "oc rsh \$pod tuned-adm active"
display_and_run "oc rsh \$pod tuned-adm list"

clear
line "NODE TUNING OPERATOR"
display_and_run "oc get tuned"
display_and_run "oc edit tuned default"
line "Lets get tuned CR files"
display_and_run "wget https://raw.githubusercontent.com/skordas/demos/master/NTO/nf-conntrack-max.yaml https://raw.githubusercontent.com/skordas/demos/master/NTO/performance.yaml"
display_and_run "vim nf-conntrack-max.yaml"
display_and_run "oc create -f nf-conntrack-max.yaml"
display_and_run "oc get tuned"
display_and_run "oc edit tuned rendered"
display_and_run "oc debug node/\$node -- chroot /host sysctl net.netfilter.nf_conntrack_max"
display_and_run "oc label pod \$pod tuned.openshift.io/elasticsearch="
display_and_run "oc debug node/\$node -- chroot /host sysctl net.netfilter.nf_conntrack_max"
display_and_run "oc delete tuned nf-conntrack-max"
display_and_run "oc debug node/\$node -- chroot /host sysctl net.netfilter.nf_conntrack_max"
line "Matching not only using nodes or pods but also Machine Configuration"
display_and_run "oc get machineconfig --show-labels"
display_and_run "vim performance.yaml"

clear
line "Bonus: NTO as SLO"
line "Node Tuning Operator as Second Line Operator"
line "Operator can be in three states:"
indent_line "- Managed"
indent_line "- Unmanaged"
indent_line "- Removed"
display_and_run "oc get pods -n openshift-cluster-node-tuning-operator"
display_and_run "oc patch tuned/default -p '{\"spec\":{\"managementState\": \"Removed\"}}' --type merge -n openshift-cluster-node-tuning-operator"
display_and_run "oc get pods -n openshift-cluster-node-tuning-operator"
display_and_run "oc patch tuned/default -p '{\"spec\":{\"managementState\": \"Managed\"}}' --type merge -n openshift-cluster-node-tuning-operator"
display_and_run "oc get pods -n openshift-cluster-node-tuning-operator"

clear
line "Q&A"
cleaning
