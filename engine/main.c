#include <stdio.h>

int _invoke(void (*print_si)(int), void (*print_ui)(unsigned), int (*print_c)(int), int (*print_s)(const char *));

void _print_si(int x) {
	printf("%d\n", x);
}

void _print_ui(unsigned x) {
	printf("%u\n", x);
}

int main() {
	int r = _invoke(&_print_si, &_print_ui, &putchar, &puts);
	printf("%d\n", r);
	return 0;
}
