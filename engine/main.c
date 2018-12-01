#include <stdio.h>

int _invoke(void (*print_si)(int), void (*print_ui)(unsigned));

void _print_si(int x) {
	printf("%d\n", x);
}

void _print_ui(unsigned x) {
	printf("%u\n", x);
}

int main() {
	int r = _invoke(&_print_si, &_print_ui);
	printf("%d\n", r);
	return 0;
}
