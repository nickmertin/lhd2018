#!/bin/bash
arm-none-eabi-as invoke.s -o invoke.o
arm-none-eabi-gcc -c main.c -o main.o
