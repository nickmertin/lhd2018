	.text
	.arm

	.globl _invoke
_invoke:
	push {fp, lr}
	bl	setup
	pop	{r0-r3}
	bl	test
	pop {fp, pc}
