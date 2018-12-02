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
STR_COUNT=0
STR_EXTRA=
echo ".text"
echo ".globl setup"
echo "setup:"
for arg; do
if [ "$arg" = "" ]; then
	break
fi
IFS=':' read -r type value <<< "$arg"
case "$type" in
	"int")
	case "$value" in
		''|*-?[!0-9]*)
		echo "Error: argument is not in integer format!" >&2
		exit 1
		;;
	esac
	echo "ldr r0, =$value"
	;;
	"str")
	echo "ldr r0, =_str_$STR_COUNT"
	STR_LINE="_str_$STR_COUNT: .asciz "
	STR_LINE=$STR_LINE$'\"'$(printf %q "$value")$'\"'$'\n'
	STR_EXTRA=$STR_EXTRA$STR_LINE
	STR_COUNT=$(($STR_COUNT+1))
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
	"print_s")
	echo "ldr r0, [r1, #12]"
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
echo "$STR_EXTRA"
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
mkdir lib
mount --bind /lib lib
chroot --userspec=lhd2018:lhd2018 . /exe
RESULT=$?
umount lib
exit $RESULT
