	.text
	.arm

	.globl _invoke
_invoke:
	push	{r0, r1, fp, lr}
	mov	r1, sp
	bl	setup
	pop	{r0-r3}
	bl	test
	add	sp, #8
	pop	{fp, pc}
