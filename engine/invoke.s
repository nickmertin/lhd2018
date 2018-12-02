	.text
	.arm

	.globl _invoke
_invoke:
	push	{fp, lr}
	push	{r0-r3}
	mov	r1, sp
	bl	setup
	pop	{r0-r3}
	bl	test
	add	sp, #16
	pop	{fp, pc}
