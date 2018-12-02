#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/stat.h>

int _invoke(void (*print_si)(int), void (*print_ui)(unsigned), int (*print_c)(int), int (*print_s)(const char *));

void _print_si(int x) {
	printf("%d\n", x);
}

void _print_ui(unsigned x) {
	printf("%u\n", x);
}

int main(int argc, char **argv) {
	if (getpid() != 1) {
		kill(1, 9);
		return -1;
	}
	uid_t uid = atoi(argv[1]);
	if (!uid || setreuid(uid, uid)) {
		return uid ? errno : -1;
	}
	if (fork()) {
		sleep(1);
	} else {
		int r = _invoke(&_print_si, &_print_ui, &putchar, &puts);
		printf("%d\n", r);
	}
	return 0;
}
