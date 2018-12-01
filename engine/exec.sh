#!/bin/bash
AS=arm-linux-gnueabihf-as
LD=arm-linux-gnueabihf-ld
ROOT=/home/nmertin/lhd2018/engine

ID=$RANDOM

mkdir -p /tmp/lhd2018/$ID
cd /tmp/lhd2018/$ID
cat > code.s
if ! $AS code.s -o code.o; then
	exit 1
fi
echo $*
(
echo ".text"
echo ".globl setup"
echo "setup:"
for arg in $@; do
if [ "$arg" = "" ]; then
	break
fi
IFS=':' read -r type value <<< "$arg"
case "$type" in
	"int")
	#if ! [[ $value =~ '^[0-9]+' ]]; then
	case $value in
	''|*[!0-9]*)
		echo "Error: argument is not in integer format!" >&2
		exit 1
	#fi
	;;
	esac
	echo "ldr r0, =$value"
	;;
	*)
	echo "Error: invalid arg type $type!" >&2
	exit 1
	;;
esac
echo "push {r0}"
done
echo "bx lr"
) > setup.s
if ! $AS setup.s -o setup.o; then
	exit 1
fi
if ! $LD code.o setup.o $ROOT/main.o -o exe; then
	exit 1
fi
