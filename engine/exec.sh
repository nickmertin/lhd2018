#!/bin/bash
AS=as
CC=gcc
ROOT=/root/lhd2018/engine

ID=$RANDOM

mkdir -p /tmp/lhd2018/$ID
cd /tmp/lhd2018/$ID
cat > code.s
if ! $AS code.s -o code.o; then
	exit 1
fi
if ! (
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
	case $value in
		''|*-?[!0-9]*)
		echo "Error: argument is not in integer format!" >&2
		exit 1
		;;
	esac
	echo "ldr r0, =$value"
	;;
	"print_si")
	echo "ldr r0, [r1]"
	;;
	"print_ui")
	echo "ldr r0, [r1, #4]"
	;;
	"print_c")
	echo "ldr r0, [r1, #8]"
	;;
	"none")
	echo "mov r0, #0"
	;;
	*)
	echo "Error: invalid arg type $type!" >&2
	exit 1
	;;
esac
echo "push {r0}"
done
echo "bx lr"
) > setup.s; then
	exit 1
fi
if ! $AS setup.s -o setup.o; then
	exit 1
fi
if ! $CC code.o setup.o $ROOT/main.o $ROOT/invoke.o -o exe; then
	exit 1
fi
echo
./exe
exit $?
