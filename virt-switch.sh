#!/bin/bash

stopKVM () {
	sudo systemctl stop libvirtd
	for p in `ps aux | grep libvirt | awk '{print $2}'`
	do 
		sudo kill ${p}
	done
	sudo modprobe -r kvm_intel
	sudo modprobe -r kvm
}

startKVM () {
	sudo modprobe kvm
	sudo modprobe kvm_intel
	sudo systemctl start libvirtd
	export VAGRANT_DEFAULT_PROVIDER=libvirt
}

stopVBOX () {
	sudo modprobe -r vboxpci
	sudo modprobe -r vboxnetadp
	sudo modprobe -r vboxnetflt
	sudo modprobe -r vboxdrv
}

startVBOX () {
	sudo modprobe vboxdrv
	sudo modprobe vboxnetflt
	sudo modprobe vboxnetadp
	sudo modprobe vboxpci
	export VAGRANT_DEFAULT_PROVIDER=virtualbox
}
