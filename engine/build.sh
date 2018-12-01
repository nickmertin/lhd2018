#!/bin/bash
arm-linux-gnueabihf-as invoke.s -o invoke.o
arm-linux-gnueabihf-gcc -c main.c -o main.o
