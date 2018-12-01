	.text
	.arm

	.globl _invoke
_invoke:
	push {fp, lr}
	bl	setup
	pop	{r0}
	bl	test
	pop {fp, pc}
